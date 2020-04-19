# funciontality : functional tests based on simple senarios

#==============================================================================
# %% MPC controller (algorithm: dynamic programming)
# % objective:  
# % constraints:
# algorithm
#==============================================================================
#import cvxpy as cp
from __future__ import print_function
from pandas import *
import numpy as np
from numpy import *
from matplotlib.pyplot import *
import matplotlib.pyplot as pp
import time
from scipy.linalg import block_diag
import scipy as sp
from H_blkdiag import H_blkdiag
import PnP_subfunc
from PnP_subfunc import H_vec
from drawnow import drawnow, figure
import scipy as sp
import control.matlab as ctool
from H_utility import *

class H_DP_Merced_Simple:
    def __init__(obj,MOD,Ts_hr,Np,Nblk,**varargindic):
        
       obj.Np0=Np;
       obj.Np=obj.Np0;
       obj.Ts_hr=Ts_hr;
       obj.Ts=Ts_hr*3600;
       
       #obj.f_CHOL=lambda ;
       #obj.f_CHCL=CHCLM;
       #obj.f_IS=IS;
       # Cs = rho*V*Cv*(Th-Tc)
       
       if ('simobj' in varargindic.keys()) and ('test' not in varargindic.keys()):
           simobj=varargindic['simobj']
           obj.paramlist=simobj.fmuinpy.get_model_variables(filter='H_par_*').keys()
           obj.Qtonmax=2*simobj.fmuinpy.get('H_par_QCHL_ton')[0]; # two chillers
           obj.V=pi*simobj.fmuinpy.get('tankMB_H2_1.Radius')**2*(simobj.fmuinpy.get('tankMB_H2_1.h_startA')+simobj.fmuinpy.get('tankMB_H2_1.h_startB'))
           obj.rho=simobj.fmuinpy.get('tankMB_H2_1.mediumB.d')
           obj.cv=4.2 # kJ/kg-C
           obj.Cs=obj.rho*obj.V*obj.cv*(f2c(55)-f2c(40))# [kJ] worst case
           obj.Cs_tonhr=kJ2tonhr(obj.Cs)
           obj.mmax=simobj.fmuinpy.get('mEva_flow_nominal')[0]
           obj.COP=simobj.fmuinpy.get('H_par_COP_nominal')[0]
           
       else:
           obj.V=pi*20**2*15
           obj.rho=1e3
           obj.cv=4.2 # kJ/kg-C
           obj.Cs=obj.rho*obj.V*obj.cv*(f2c(55)-f2c(40))# [kJ] worst case
           obj.Cs_tonhr=kJ2tonhr(obj.Cs)
           try:
               obj.Qtonmax=varargindic['Qtonmax'];#3000; # two chillers
           except:
               obj.Qtonmax=3000; # two chillers
           obj.COP=7;
           
       
       
       # define grid
       obj.X=linspace(0.1,0.9,30)
       
       
       obj.U=hstack((-linspace(ton2kW(obj.Qtonmax),ton2kW(0.1),num=30),
                     0.,
                     linspace(ton2kW(0.1),ton2kW(obj.Qtonmax),num=30)))
    
       obj.PRED=DataFrame()

    def f(obj,xk,uk,wk):
        xkp1=xk-uk*1./obj.Cs*obj.Ts
        return xkp1
    
    def g_feasible(obj,xk,uk,wk,xkp1):
        # h(x)=0
        # g(x)<=0
        QBL=wk[0];
        QDIS=uk; 
        QCHL=QBL-QDIS; # equality constraints (optimial distribution prob)
        
        # note stage bounds aren't applied to this
        feasible=(0.1<=xkp1) & (xkp1<=0.9) \
                & ( QDIS <= ton2kW(obj.Qtonmax)+ 0*gpm2kgs(2000)*obj.cv*(f2c(50)-f2c(40)) ) \
                & (-QDIS <= ton2kW(obj.Qtonmax) + 0*gpm2kgs(2000)*obj.cv*(f2c(50)-f2c(40)) )  \
                & (QCHL>=0) & (QCHL<=ton2kW(obj.Qtonmax))
                
        return feasible
    
    def phi(obj,xk,uk,wk):
        QBL=wk[0]
        ER=wk[1]
        PnonHVAC=wk[2]
        Psolarpv=wk[3]
        COP=obj.COP*1.
        stagecost=ER*max(1./COP*(QBL-uk)+PnonHVAC-Psolarpv,0);
        return stagecost

    def M(obj,xk):
        mier=1e6*min(xk-0.5,0)**2
        return mier
        

    def BellmanEq(obj,Ws):
        X=obj.X
        U=obj.U
        N=obj.Np
        print("In Bellam, ",  "Np:",obj.Np, "W:", Ws.shape)
        
        S=X.shape[0]
        C=U.shape[0]
        # K=1
        Vok=nan*ones((S,N+1));   # Optimal cost to go from k to N at x (x,k)|--> V*(x,k) in R
        
        for i in range(S):
            Vok[i,-1]=obj.M(X[i]);     # terminal cost
        print(Vok[:,-1].T)
        # Vok =
        #  k  0  1  2 .. N
        # x1 [            ]
        # x2 [            ]
        # kb  N ..      1 0
        
        Uok=nan*ones((S,N));   # Optimal input map (x,k)|--> uk that is u*(x,k) in Rm
        # Uok =
        #  k  0  1  2 .. N-1 N
        # x1 [              ]
        # x2 [              ]
        # kb  N ..        1   
        for kb in range(1,N+1): # note backward
            wk=Ws[N-kb,:].T
            #print kb,wk
            
            for i in range(S):
                xk=X[i];   # let current state := X(i)
                dummy=1e10;   # initital estimation of optitmal cost to go from k to N given xi
                for j in range(C):
                    uk=U[j]; # current input := U(j)
                    xkp1=obj.f(xk,uk,wk) ;# next state
                    if obj.g_feasible(xk,uk,wk,xkp1):
                        Vokp1xp1=interp(xkp1,X,Vok[:,N-kb+1]);#,right=1e10); # optimal cost to go from k+1 to N at xkp1
                        # Note it is a known function, e.g. terminal cost if kb=1
                        Vkxu=obj.phi(xk,uk,wk)+Vokp1xp1; # a cost from k to N at xi with uj 
                    else: # infeasible
                        Vkxu=1e10
                        
                    if Vkxu<dummy:
                        dummy=Vkxu;
                        Uok[i,N-kb]=uk;
                
                    Vok[i,N-kb]=dummy;
                # end of optimization (all inputs) at a given x and k
            #end of optimization for all x at k
        #end of optimization for all k
        return Vok,Uok
        
    def modelprediction(obj,x0,W,U,*varargin):
        # extract optimal control input traj for x[0]=x0
        x=nan*random.random((obj.Np+1,1))
        UTR=nan*random.random((obj.Np,1))
        phik=nan*random.random((obj.Np,1))
        x[0]=x0;
        T=arange(0,obj.Np+1,1)
        for k in range(obj.Np):
            wk=W[k,:].T
            UTR[k]=U[k]; ##<< the only difference
            x[k+1]=obj.f(x[k],UTR[k],wk)
            phik[k]=obj.phi(x[k],UTR[k],wk)
            
        if len(varargin) is not 0:
            figure(2)
            subplot(211)
            plot(T,x,'o-');grid(True);            
            title('MPCthink')
            subplot(212)
            pp.step(T[:-1],kW2ton(UTR),'-o',where='post');#ylim([-1,1.5])
            grid(True)
            figure(3)
            subplot(211)
            plot(T[:-1],hstack((kW2ton(H_iscolumn(W[:,0])),kW2ton(UTR))),'-o')
            legend(['QBL','QDIS'])
            title('MPCthink')
            print(phik.shape)
            subplot(212)
            plot(T[:-1],hstack((H_iscolumn(W[:,2]),H_iscolumn(W[:,3]),phik)),'-o')
            legend(['Pnonhvac','Psolar','phik $'])
            
        print(phik.sum())
        return x, phik
        
        
    def controller(obj,x0,W,*varargin):
        
        # solve Bellman equation
        #print("Np:",obj.Np, "W:", W.shape)
        (Vok,Uok)=obj.BellmanEq(W)   
        # extract optimal control input traj for x[0]=x0
        x=nan*random.random((obj.Np+1,1))
        UTR=nan*random.random((obj.Np,1))
        phik=nan*random.random((obj.Np,1))
        x[0]=x0;
        T=arange(0,obj.Np+1,1)
        for k in range(obj.Np):
            wk=W[k,:].T
            UTR[k]=interp(x[k],obj.X,Uok[:,k]);#,right=1e10)
            x[k+1]=obj.f(x[k],UTR[k],wk)
            phik[k]=obj.phi(x[k],UTR[k],wk)
            
        if len(varargin) is not 0:
            
            if varargin:
                QCHL=H_iscolumn(W[:,0])-H_iscolumn(UTR)
                figure(2)
                    
                subplot(311)
                if mean(W[:,3])==0:      
                    plot(T[:-1],kW2ton(QCHL),'ro-')
                    plot(T[:-1],kW2ton(H_iscolumn(W[:,0])),'go-')
                    legend(['QCHL$_{before}$','QBL'])
                else:
                    plot(T[:-1],kW2ton(QCHL),'bo-',linewidth=2)
                    legend(['QCHL$_{before}$','QBL','QCHL$_{after}$'])
                ylabel('Cooling ton')
                xlim([0,24])
                ylim([0,3000])
                grid(True)
                
                subplot(312)
                if mean(W[:,3])==0:             
                    plot(T[:-1],H_iscolumn(QCHL/obj.COP),'ro-')
                else:
                    plot(T[:-1],H_iscolumn(QCHL/obj.COP),'bo-',linewidth=2)
                    plot(T[:-1],H_iscolumn(W[:,3]),'go-')
                    legend(['P$_{before}$','P$_{after}$','P$_{solar}$'])
                ylabel('Power [kW]')
                xlim([0,24])
                ylim([0,2000])
                grid(True)
                
                subplot(313)
                if mean(W[:,3])==0:             
                   plot(T,x,'ro-');grid(True);
                else:
                   plot(T,x,'bo-',linewidth=2);grid(True);
                 
                ylabel('State of Charge [%]')
                grid(True)
                xlabel('hour')
                xlim([0,24])
                ylim([0.4,0.8])
                
            
        print(phik.sum())
        return UTR, phik.sum()
        
                
#%% system speicific
    def exeMPC(obj,cur_t,x0,W,**varargindic):
        if 'adjustNp' in varargindic.keys():
            if varargindic['adjustNp']:
                Wf=obj.adjustNp(cur_t,x0,W)
        else:
            Wf=W;
        if 'wannaplot' in varargindic.keys():
            wannaplot=varargindic['wannaplot']
        
        (Uop,phi)=obj.controller(x0,Wf,wannaplot)  
        (x,phi)=obj.modelprediction(x0,Wf,Uop)
        
        
        df=DataFrame(data={'cur_t':cur_t,'Uop':np.squeeze(Uop.T),'x':np.squeeze(x[:-1].T),'phi':np.squeeze(phi.T)})
        print(df.head(3))
        
        obj.PRED=obj.PRED.append(df) # datasave
        return Uop
        
    def adjustNp(obj,cur_t,x0,W,**varargindic):
        if np.remainder(cur_t,3600*24*1)==0: #for every day at 0:00, reset Np as Np0
            obj.Np=obj.Np0
        else: # reduce Np and the corresponding W
            obj.Np=obj.Np-1
        print('Np adjusted:', obj.Np)
        Wf=W[:obj.Np,:]
        #print('in adjustNp', 'adjusted W:', Wf.shape, 'orginal W', W.shape)
        return Wf
            
    def IOmapping(obj,Uop,Ws): # mapping from optimization variables to physical variables
        # conversion of decision variable to manipulatable input (defined by simobj.key_u)
        CHON=ones((obj.Np,1))
        SP_mCH=nan*zeros((obj.Np,1))
        TCHeSP=nan*zeros((obj.Np,1))
        hatmr=nan*zeros((obj.Np,1))
        
        Tsc=f2c(39)
        Tsh=f2c(50)
        Tr=f2c(40)+5
        
        for k in range(obj.Np):
            QBL=Ws[k,0]
            if QBL<0:
                error()
            hatmr[k]=QBL/(4.2*5) # assume 5 oc drop
            
            if Uop[k]>0: # discharging
                QDIS=Uop[k]
                QCHL=QBL-QDIS
                msdis=QDIS/(obj.cv*(Tr-Tsc))
                SP_mCH[k]=hatmr[k]-msdis
                TCHeSP[k]=Tr-QCHL/(SP_mCH[k]*obj.cv)
            if Uop[k]<0: # charging
                QCHA=-Uop[k]
                QCHL=QBL+QCHA
                Tsup0=4;
                mscha=QCHA/(obj.cv*(Tsh-Tsup0))
                SP_mCH[k]=hatmr[k]+mscha
                Tmix=mscha/(hatmr[k]+mscha)*Tsh+hatmr[k]/(hatmr[k]+mscha)*Tr
                TCHeSP[k]=Tmix-QCHL/(SP_mCH[k]*obj.cv)
        uop=np.hstack((CHON,SP_mCH,TCHeSP))
        zop=hatmr
        return uop,zop      
        
    def analysis(obj):
        times=np.unique(obj.PRED['cur_t'].values)
        for t in times:
            ydf=obj.PRED[obj.PRED['cur_t']==t]
            hr=(t+arange(0,ydf.shape[0])*obj.Ts*1.)/3600
            print(t, hr.size)
            
            figure(10)
            subplot(311)
            plot(hr,ydf['Uop']);grid(True);title('Uop')
            subplot(312)
            plot(hr,ydf['x']);grid(True);title('x')
            subplot(313)
            plot(hr,ydf['phi']);grid(True);title('phi')
                
#%% test object
if __name__ is '__main__':
    import scipy.signal
    
    close('all')
    MOD=list()
    Ts_hr=1;
    Np=1*24;
    Nblk=Np;
    
    T=arange(0,7*24*3600,3600)
    W=hstack((filtfilt(3,H_schedule(T[:-1],[7,19],ton2kW(1.5*1e3),0)), #BL
              H_schedule(T[:-1],[7,19],3,1),   # price
              filtfilt(3,H_schedule(T[:-1],[7,19],0*1000,0)),  # PnonHVAC
              filtfilt(3,H_schedule(T[:-1],[10,15],1*2000,0)))) #Psolar

    obj=H_DP_Merced_Simple(MOD,Ts_hr,Np,Nblk)
    x0=0.5
    cur_t=0
    
    # functional tests for some senarios
    obj.exeMPC(cur_t,x0,W[:Np,:],wannaplot=True)
    #(Vok,Uok)=obj.BellmanEq(W)
    
#    #%% functional tests for adaptive scheme
#    obj=H_DP_Merced_Simple(MOD,Ts_hr,Np,Nblk)
#    start_t=0
#    xk=x0
#    for k in range(30):
#        cur_t=start_t+Ts_hr*3600*k
#        Uo=obj.exeMPC(cur_t,xk,W[k:(k+Np),:],wannaplot=True,adjustNp=True)
#        uk=Uo[0]
#        wk=W[k,:]
#        xk=obj.f(xk,uk,wk)
#  
#    
#    obj.analysis()
    