# funciontality : simulation based on schedule
# MPC tests for 1) local controller & setpoint, 2) prediction comparison

from pandas import *
from H_utility import *
import numpy as np
from numpy import *
import matplotlib.pyplot as mp
import time
from scipy.linalg import block_diag
import scipy as sp
from H_blkdiag import H_blkdiag
import PnP_subfunc
from PnP_subfunc import H_vec
import scipy as sp
import scipy.interpolate
import control.matlab as ctool
import pyfmi

class H_simobj:
    def __init__(obj,**varagindic):
        obj.dt=varagindic['dt']
        obj.start_time=varagindic['start_time']
        obj.final_time=varagindic['final_time']
        obj.T=arange(obj.start_time,obj.final_time,obj.dt)
        obj.Ndata=len(obj.T)        
        obj.modelname=varagindic['modelname']
        obj.modelicafile=varagindic['modelicafile']
        if 'fmu' not in varagindic.keys():            
            import pymodelica
            obj.myfmu=pymodelica.compile_fmu(obj.modelname,obj.modelicafile,target='me',version='2.0')
        else:
            obj.myfmu=varagindic['fmu']
        obj.fmuinpy=pyfmi.load_fmu(obj.myfmu)
           
        obj.MOD=dict()
        obj.DATA=DataFrame()
        
        obj.key_u=varagindic['key_u']
        obj.key_w=varagindic['key_w']
        obj.key_y=varagindic['key_y']
        obj.key_x=varagindic['key_x']
        obj.mc=len(obj.key_u)
        obj.md=len(obj.key_w)
        obj.n=len(obj.key_x)
        
        obj._sim_opts=obj.fmuinpy.simulate_options()
        #opt['solver']='Radau5ODE'
        #opt['Radau5ODE_options']['rtol']=1e-6
        obj._sim_opts['result_handling']='memory' 
        #obj._sim_opts['filter'] = obj.key_u + obj.key_w + obj.key_y + list(obj.key_x)
        
    def simulate_schedule(obj,x0_val,schedule,**varargindic):
        
        obj.u_schedule=schedule['u']        
        obj.w_schedule=schedule['w']
        obj.t_schedule=schedule['t']
        
        obj.fmuinpy=pyfmi.load_fmu(obj.myfmu)
        
        obj.fmuinpy.set(obj.key_x,x0_val)
        
        
        IN=(obj.key_u+obj.key_w,hstack((obj.t_schedule,obj.u_schedule,obj.w_schedule)))
        obj._sim_opts['ncp'] = IN[1].shape[0]-1 #Specify a number of output points that should be returned
        res0=obj.fmuinpy.simulate(start_time=obj.t_schedule[0],final_time=obj.t_schedule[-1], options=obj._sim_opts, input=IN)
        obj.res0=res0

        if len(varargindic)!=0:
            if 'wannaplot' in varargindic.keys():
                obj.plotresult(res=obj.res0)
        
        return res0, IN
        
     
    def plotresult(obj,**varargindic):
        if len(varargindic)==0:
            res=obj.res0
        else:
            res=varargindic['res']
        data=DataFrame(columns=obj.key_y)  
        for k in obj.key_y:
            data[k]=res[k]
        data.index=data.time
        
        data.plot(x='time',y=[k for k in obj.key_y if '.m_flow' in k])
        data.plot(x='time',y=[k for k in obj.key_y if '.T' in k])
        data.plot(x='time',y=[k for k in obj.key_y if 'Height' in k])
        data.plot(x='time',y=[k for k in obj.key_y if 'Output' in k])
    

    
    def getidmodel(obj,idmodel):
        import scipy as sp
        obj.idmodel=idmodel
        obj.MOD=sp.io.loadmat(obj.idmodel)
        
    def MPCsetup(obj,**varargindic):
        
        obj.Np= int(varargindic['Npday']*24*3600./obj.dt)     # 24 hr prediction
        obj.Nblk= obj.Np#Np/6 # 30 min size blk for time scale seperation
        obj.Ts_hr=1.*obj.dt/3600 # in hr
        if 'test' in varargindic:  
            obj.MPCobj=varargindic['MPCobj'](obj.MOD,obj.Ts_hr,obj.Np,obj.Nblk,simobj=obj,test=varargindic['test'])
        else:
            obj.MPCobj=varargindic['MPCobj'](obj.MOD,obj.Ts_hr,obj.Np,obj.Nblk,simobj=obj)

   
    def does_local_follow_mpc(obj,x0_val): # one shot MPC and feed it to system (open-loop control)
    
        #obj.myfmu=pymodelica.compile_fmu(obj.modelname,obj.modelicafile,target='me',version='2.0')
        obj.fmuinpy=pyfmi.load_fmu(obj.myfmu)
        
        pre_t=obj.start_time+linspace(0,obj.MPCobj.Np0-1,obj.MPCobj.Np0)*obj.dt # in sec 
        xk=x0_val    
        # prediction
        WInterpFun=sp.interpolate.interp1d(squeeze(obj.t_schedule.T),obj.w_schedule.T,kind='previous')
        try:
            Ws=mat(WInterpFun(pre_t)).T
        except:
            pre_tcap=pre_t
            pre_tcap[pre_t>=max(obj.t_schedule)]=max(obj.t_schedule)
            Ws=mat(WInterpFun(pre_tcap)).T
            
        # optimization : (Vok,Uok)=obj.MPCobj.BellmanEq(Ws)   
        Uop,totalcost=obj.MPCobj.controller(xk,Ws,0)
        (hatx,hatphi)=obj.MPCobj.modelprediction(xk,Ws,Uop,1)
        #Uop=obj.MPCobj.exeMPC(cur_t,xk,Ws,wannaplot=False,adjustNp='y')
        
        (uop,zop)=obj.MPCobj.IOmapping(Uop,Ws)
        
        IN=(obj.key_u+obj.key_w,np.array(hstack((H_iscolumn(pre_t),uop,Ws))))
        
        # system response to control
            
        obj.fmuinpy.set(obj.key_x,xk)
        res=obj.fmuinpy.simulate(start_time=pre_t[0],final_time=pre_t[-1],options = obj._sim_opts, input=IN)
    
        obj.plotresult_sysspec(res,pre_t,hatx,uop,zop,Uop,Ws,hatphi)
    
    def evaluate_mpc(obj,x0_val): 
    
        #obj.myfmu=pymodelica.compile_fmu(obj.modelname,obj.modelicafile,target='me',version='2.0')
        obj.fmuinpy=pyfmi.load_fmu(obj.myfmu)
        
        xk=x0_val   
        
        for k in range(obj.Ndata-1):
            cur_t=obj.start_time+k*obj.dt

            # supervisory level control ===========================================
            # prediction
            pre_t=cur_t+linspace(0,obj.MPCobj.Np0-1,obj.MPCobj.Np0)*obj.dt # in sec <<< Bug found, it should be Np0 not Np
            #Q: Simulation output sampling time = MPC sampling time ?
            
                
            # prediction
            WInterpFun=sp.interpolate.interp1d(squeeze(obj.t_schedule.T),obj.w_schedule.T,kind='previous')
            try:
                Ws=mat(WInterpFun(pre_t)).T
            except:
                pre_tcap=pre_t
                pre_tcap[pre_t>=max(obj.t_schedule)]=max(obj.t_schedule)
                Ws=mat(WInterpFun(pre_tcap)).T
            if Ws.shape[0] != obj.MPCobj.Np0:
                error('The size of W prediction should be the same as the original prediction horizon')
            
            
            #optimization
            Uop=obj.MPCobj.exeMPC(cur_t,xk,Ws,wannaplot=False,adjustNp='y')
            (uop,zop)=obj.MPCobj.IOmapping(Uop,Ws)
        
            IN=(obj.key_u+obj.key_w,np.array(hstack((H_iscolumn(pre_t[:2]),kron(array([[1],[1]]),uop[0,:]),
                                                     kron(array([[1],[1]]),Ws[0,:]))))) # Fixed inputs, no interpolation
        
            # system response to control
            if k != 0:
                obj._sim_opts['initialize'] = False
            else: # initialization
                obj.fmuinpy.set(obj.key_x,xk)
            
            res=obj.fmuinpy.simulate(start_time=cur_t,final_time=cur_t+obj.dt,options = obj._sim_opts, input=IN)
            xk=mat(res['Sensor_Height[3]'][-1])
            
            obj.storeresponse(res)
            
    
    def storeresponse(obj,res):
        data=DataFrame(columns=obj.key_u+obj.key_y+obj.key_w)  
        for k in obj.key_u+obj.key_y+obj.key_w:
            data[k]=res[k][:-1]
        #data.index=data.time
        obj.DATA=obj.DATA.append(data)
        
#%% system specific             
        
    def plotresult_sysspec(obj,res,pre_t,hatx,uop,zop,Uop,Ws,hatphi):
        data=DataFrame(columns=obj.key_u+obj.key_y+obj.key_w)  
        for k in obj.key_u+obj.key_y+obj.key_w:
            data[k]=res[k]
        data.index=data.time
        obj.res=res
        figure(100)
        plot(to_datetime(H_simtime2date(data['time'],'2018')),kW2ton(data['Output[3]']))     
        plot(to_datetime(H_simtime2date(data['time'],'2018')),kW2ton(data['Output[4]']),'r')
        plot(to_datetime(H_simtime2date(pre_t,'2018')),kW2ton(hstack((Ws[:,0]-Uop,Uop))),'o')
        legend(['QCHL','QDIS'])
        ylabel('ton')
        title('is the system following my capacity order?')
        
        SP_mCH=uop[:,1]        
        data.plot(x='time',y=[k for k in obj.key_y if '.m_flow' in k])
        plot(pre_t,SP_mCH,'o')
        title('is the local controller for the primiary pump follow my order?')
        
        hatmr=zop[:,0]
        figure(102)
        plot(to_datetime(H_simtime2date(data['time'],'2018')),data['Sensor_msup.m_flow'])     
        plot(to_datetime(H_simtime2date(pre_t,'2018')),hatmr,'o')
        ylabel('return flow rate')
        title('is the model for return m or T ok ?')
        
        figure()
        data.plot(x='time',y=[k for k in obj.key_y if 'Height[3]' in k])    
        plot(pre_t,hatx[:-1],'o')
        title('Model Validation: state of charge')
        
        figure()
        data.plot(x='time',y=[k for k in obj.key_y if 'Output[1]' in k])
        mp.step(pre_t,hatphi,'o',where='post')
        title('Model Validation: $\phi$')    
        
    def analysis_performance(obj):
        data=obj.DATA
        figure(1000)
        plot(data['time']/(3600*24),kW2ton(data['Output[3]']),linewidth=3)     
        plot(data['time']/(3600*24),kW2ton(data['Output[4]']),'r',linewidth=3)
        times=np.unique(obj.MPCobj.PRED['cur_t'].values)
        for t in times:
            ydf=obj.MPCobj.PRED[obj.MPCobj.PRED['cur_t']==t]
            hr=(t+arange(0,ydf.shape[0])*obj.MPCobj.Ts*1.)/3600
            plot(hr*1./24,kW2ton(ydf['Uop']),'--')
        grid(True)
        legend(['QCHL','QDIS'])
        ylabel('ton')
        
        figure(1001)
        plot(data['time']/(3600*24),data[[k for k in obj.key_y if '.m_flow' in k]].apply(kgs2gpm))
        plot(data['time']/(3600*24),data['SP_mCH'].apply(kgs2gpm),'o',linewidth=3)
        ylabel('gpm')
        grid(True)
        legend([k for k in obj.key_y if '.m_flow' in k])
        
        
        figure(1002)
        plot(data['time']/(3600*24),data[[k for k in obj.key_y if 'Height[3]' in k]],linewidth=3)
        times=np.unique(obj.MPCobj.PRED['cur_t'].values)
        for t in times:
            ydf=obj.MPCobj.PRED[obj.MPCobj.PRED['cur_t']==t]
            hr=(t+arange(0,ydf.shape[0])*obj.MPCobj.Ts*1.)/3600
            plot(hr*1./24,ydf['x'],'--')
        grid(True)
        title('model validation: state of charge')
        
        figure(1003)
        plot(data['time']/(3600*24),data[[k for k in obj.key_y if 'Output[1]' in k]],linewidth=3)
        times=np.unique(obj.MPCobj.PRED['cur_t'].values)
        for t in times:
            ydf=obj.MPCobj.PRED[obj.MPCobj.PRED['cur_t']==t]
            hr=(t+arange(0,ydf.shape[0])*obj.MPCobj.Ts*1.)/3600
            mp.step(hr*1./24,ydf['phi'] ,where='post')
        grid(True)
        title('model validation: $ \phi $')
        
        
        #if 'wannaplot' in varargindic.keys():
            # MPC specific: I would better just give dataframe output and let users to make their own post
            # but only give default maybe too comprehensive result data
        figure(104)
        subplot(311)
        plot(data['time']/(3600*24),data[[k for k in obj.key_y if '.T' in k]]-273.15)
        legend([k for k in obj.key_y if '.T' in k])
        subplot(312)
        plot(data['time']/(3600*24),data[[k for k in obj.key_y if 'Height' in k]])
        legend([k for k in obj.key_y if 'Height' in k])
        subplot(313)        
        plot(data['time']/(3600*24),data[[k for k in obj.key_y if 'Output' in k]])
        legend([k for k in obj.key_y if 'Output' in k])
            #return IN
        
    def mo2keys(obj,fmuinpy):
        UW=fmuinpy.get_model_variables(causality=0)
        Y=fmuinpy.get_model_variables(causality=1)
        C=fmuinpy.get_model_variables(variability=1)
        obj.key_uw=UW.keys()
        obj.key_y=Y.keys()
        obj.key_c=[k for k in C.keys() if '_' not in k]
        

#%%         
if __name__ is '__main__':
    
    close('all')
    
    modelname='Merced.CoolingPlantNew.Chiller_Storage_Only_V2_MPC'
    modelicafile='/home/adun6414/Work/CERC_UCM/Merced/CoolingPlantNew/Chiller_Storage_Only_V2_MPC.mo'
    dt=30*60; # 30 min sampling time
    start_time=H_date2simtime(to_datetime('2018-08-01 00:00'),'2018')
    final_time=H_date2simtime(to_datetime('2018-08-01 23:45'),'2018')
    simtimes=arange(start_time,final_time,dt)
    simtimedate=date_range(start=H_simtime2date(start_time,'2018'),end=H_simtime2date(final_time,'2018'),freq=str(int(30*60./60))+'T')

    
    key_x='x0'
    x0_val=0.2; # initial state of charge
    # inputs (controllable variables)
    key_u=['ChillerON','SP_mCH', 'TCHeSP']
    # inputs: disturbance
    key_w=['BuildingCoolingLoads', 'ER', 'PnonHVAC', 'Psolarpv']
    # outputs of interests
    key_y=['Output[1]','Output[2]','Output[3]','Output[4]','Sensor_TCHWS.T','Sensor_TCHWR.T','Sensor_msup.m_flow','Sensor_mCHi.m_flow','Sensor_mS.m_flow','time',
          'Sensor_Tstorage[1].y','Sensor_Tstorage[2].y','Sensor_Height[1]','Sensor_Height[2]','Sensor_Height[3]']
    
    idmodel=('CASE900Load1576283834')
    
    # specify disturbances
    t_schedule=arange(start_time,final_time,dt)
    obj=H_simobj(dt=dt,start_time=start_time,final_time=final_time,modelname=modelname,modelicafile=modelicafile,idmodel=idmodel,
                 key_u=key_u,key_w=key_w,key_y=key_y,key_x=key_x)
    CHON=H_schedule(t_schedule,array([7,19]),1,1)
    mEva_flow_nominal=obj.fmuinpy.get('mEva_flow_nominal')
    SP_mCH=H_schedule(t_schedule,array([7,19]),0.*mEva_flow_nominal,0.9*mEva_flow_nominal)
    TCHeSP=H_schedule(t_schedule,array([7,19]),4,4) # C
    QBL=H_schedule(t_schedule,array([7,19]),ton2kW(500), ton2kW(0.1*500)) # kW
    ER=H_schedule(t_schedule,array([7,19]),2,1) #$/kWh
    PnonHVAC=H_schedule(t_schedule,[7,19],0*1000,0*1000) # kW
    Psolarpv=H_schedule(t_schedule,[7,19],0*500,0) # kW
              
    u=hstack((CHON,SP_mCH,TCHeSP))
    w=hstack((QBL,ER,PnonHVAC,Psolarpv))
    
    schedule={'u': u, 'w': w, 't': H_iscolumn(t_schedule)}
# conventional control simulation
    (res0,IN0)=obj.simulate_schedule(x0_val,schedule)

#%%MPC configuration
    from H_DP_Merced_Simple import H_DP_Merced_Simple

    #obj.getidmodel(idmodel='CASE900Load1576283834') # unused in DP
    obj.MPCsetup(MPCobj=H_DP_Merced_Simple,Npday=2,test=True) 
    #Q: sampling time of simluation output is the same as control implementation period?
    obj.does_local_follow_mpc(x0_val)
#%% MPC evaulation inputs: starts, final time, IC
    obj.evaluate_mpc(x0_val)
    obj.analysis_performance()
