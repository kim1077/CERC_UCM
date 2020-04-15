# funciontality : functional tests based on simple senarios

#==============================================================================
# %% MPC controller (algorithm: dynamic programming)
# % objective:  
# % constraints:
# algorithm
#==============================================================================
#import cvxpy as cp
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
       
       if len(varargindic) is not 0:              
           simobj=varargindic['simobj']
           obj.V=pi*simobj.fmuinpy.get('tankMB_H2_1.Radius')**2*(simobj.fmuinpy.get('tankMB_H2_1.h_startA')+simobj.fmuinpy.get('tankMB_H2_1.h_startB'))
           obj.rho=simobj.fmuinpy.get('tankMB_H2_1.mediumB.d')
           obj.cv=4.2 # kJ/kg-C
           obj.Cs=obj.rho*obj.V*obj.cv*(f2c(55)-f2c(40))# [kJ] worst case
           obj.Cs_tonhr=kJ2tonhr(obj.Cs)
       else:
           obj.rho=1e3
           obj.cv=4.2 # kJ/kg-C
           obj.Cs_tonhr=1000*12
           obj.Cs=tonhr2kJ(obj.Cs_tonhr)
           
       
       
       # define grid
       obj.X=linspace(0.1,0.9,30)
       
       obj.U=hstack((-linspace(ton2kW(1000),ton2kW(0.1),num=30),
                     0,
                     linspace(ton2kW(0.1),ton2kW(1000),num=30)))
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
                & ( QDIS <= ton2kW(1e3)+ 0*gpm2kgs(2000)*obj.cv*(f2c(50)-f2c(40)) ) \
                & (-QDIS <= ton2kW(1e3) + 0*gpm2kgs(2000)*obj.cv*(f2c(50)-f2c(40)) )  \
                & (QCHL>=0) & (QCHL<=ton2kW(1e3))
                
        return feasible
    
    def phi(obj,xk,uk,wk):
        QBL=wk[0]
        ER=wk[1]
        PnonHVAC=wk[2]
        Psolarpv=wk[3]
        COP=7.
        stagecost=ER*max(1./COP*(QBL-uk)+PnonHVAC-Psolarpv,0);
        return stagecost



    def BellmanEq(obj,Ws):
        X=obj.X
        U=obj.U
        N=obj.Np
        S=X.shape[0]
        C=U.shape[0]
        # K=1
        Vok=nan*ones((S,N+1));   # Optimal cost to go from k to N at x (x,k)|--> V*(x,k) in R
        Vok[:,-1]=0;     # terminal cost
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
            print phik.shape
            subplot(212)
            plot(T[:-1],hstack((H_iscolumn(W[:,2]),H_iscolumn(W[:,3]),phik)),'-o')
            legend(['Pnonhvac','Psolar','phik $'])
            
        print phik.sum()
        return x, phik
        
        
    def controller(obj,x0,W,*varargin):
        
        # solve Bellman equation
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
                figure(2)
                subplot(211)
                plot(T,x,'o-');grid(True);
                ylabel('state of charge [%]')            
                title('MPCthink')
                subplot(212)
                pp.step(T[:-1],kW2ton(UTR),'-o',where='post');#ylim([-1,1.5])
                ylabel('optimal QDIS [ton]')
                grid(True)
                figure(3)
                subplot(211)
                plot(T[:-1],hstack((kW2ton(H_iscolumn(W[:,0])),kW2ton(UTR))),'-o')
                legend(['QBL','QDIS'])
                ylabel('ton')            
                title('MPCthink')
                print phik.shape
                subplot(212)
                plot(T[:-1],hstack((H_iscolumn(W[:,2]),H_iscolumn(W[:,3]),phik)),'-o')
                legend(['Pnonhvac','Psolar','phik $'])
            
        print phik.sum()
        return UTR, phik.sum()
        
                
#%% system speicific
    def exeMPC(obj,cur_t,x0,W,**varargindic):
        if 'adjustNp' in varargindic.keys():
            if varargindic['adjustNp']:
                W=obj.adjustNp(cur_t,x0,W)
        if 'wannaplot' in varargindic.keys():
            wannaplot=varargindic['wannaplot']
        (Uop,phi)=obj.controller(x0,W,wannaplot)  
        (x,phi)=obj.modelprediction(x0,W,Uop)
        
        
        df=DataFrame(data={'cur_t':cur_t,'Uop':np.squeeze(Uop.T),'x':np.squeeze(x[:-1].T),'phi':np.squeeze(phi.T)})
        print df.head(3)
        
        obj.PRED=obj.PRED.append(df) # datasave
        return Uop
        
    def adjustNp(obj,cur_t,x0,W,**varargindic):
        if np.remainder(cur_t,3600*24*1)==0: #for every day at 0:00, reset Np as Np0
            obj.Np=obj.Np0
        else: # reduce Np and the corresponding W
            obj.Np=obj.Np-1
        print 'Np adjusted:', obj.Np
        W=W[:obj.Np,:]
        return W
            
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
            print t, hr.size
            
            figure(10)
            subplot(311)
            plot(hr,ydf['Uop']);grid(True);title('Uop')
            subplot(312)
            plot(hr,ydf['x']);grid(True);title('x')
            subplot(313)
            plot(hr,ydf['phi']);grid(True);title('phi')
                
#%% test object
if __name__ is '__main__':
    close('all')
    MOD=list()
    Ts_hr=1;
    Np=2*24;
    Nblk=Np;
    
    T=arange(0,7*24*3600,3600)
    W=hstack((H_schedule(T[:-1],[7,19],ton2kW(1e3),0),
              H_schedule(T[:-1],[7,19],3,1),
              H_schedule(T[:-1],[7,19],0*1000,0*1000), 
              H_schedule(T[:-1],[7,19],0*500,0))) # Building load, price schedule, nonHVACP, Psolargen
    
        
    obj=H_DP_Merced_Simple(MOD,Ts_hr,Np,Nblk)
    x0=0.2
    cur_t=0
    
    # functional tests for some senarios
    obj.exeMPC(cur_t,x0,W[:Np,:],wannaplot='show')
    (Vok,Uok)=obj.BellmanEq(W)
    
    #%% functional tests for adaptive scheme
    obj=H_DP_Merced_Simple(MOD,Ts_hr,Np,Nblk)
    start_t=0
    xk=x0
    for k in range(4):
        cur_t=start_t+Ts_hr*3600*k
        Uo=obj.exeMPC(cur_t,xk,W[k:(k+Np),:],wannaplot='show',adjustNp='y')
        uk=Uo[0]
        wk=W[k,:]
        xk=obj.f(xk,uk,wk)
  
    
    obj.analysis()
    
    
#    def MPC(obj,cur_ts,CLdata,Tzdata,wkm1,SPLs,SPUs,Ws,Rates):
#        # with updated measurement, i.e. y(k-1), u(k-1), estimate current (!) wall
#        # hatx(k|k-1)=Ax(k-1|k-2)+Bu(k-1)+Ke
#        obj.estimate_Tw(cur_ts,CLdata,Tzdata,wkm1)
#        # with current wall temp, optitmize setpoint at k
#        (SPopt,clk)=obj.optimize_SP(cur_ts,SPLs,SPUs,Ws,Rates)
#        
#        # predict average cooling power from k to k+1 with the decision made
#        # haty(k)=Cx(k|k-1)+Du(k)
#        obj.predict_AvgCoolingLoad(SPopt,Ws[0,:].T)
#        
#        return (SPopt,clk) 
#        
#    
#    def estimate_Tw(obj,cur_ts,CLdata,Tzdata,wkm1): 
#        inno=CLdata-obj.hatCL # measured, predicted
#        # estimate current 
#        obj.hatx=obj.a*obj.hatx+obj.b*np.vstack((Tzdata,wkm1))+obj.k*np.mat(inno) # x(k+1|k)
#        obj.MEASt.append(cur_ts)        
#        obj.MEAST.append(Tzdata)
#        obj.MEASCE.append(CLdata)
#        if obj.verbose:
#            #print('current mean temps are ', hatxmk.T)
#            print('innovation is : ',inno, '[kW]')
#            
#    def predict_AvgCoolingLoad(obj,SPk,wk):
#        obj.hatCL=obj.c*obj.hatx+obj.d*np.vstack((SPk,wk)) # y(k|k-1)=Cx(k|k-1)+Du(k)
#    
#        
#    def predict_Np(obj,cur_ts,SPs,Ws):
#        inputpreddata=np.hstack((np.array(SPs),np.array(Ws)))
#        
#        tpred=np.array(range(obj.Np))*obj.Ts    #[hr]
#        T, Y, X = sp.signal.dlsim(obj.G,inputpreddata,t=tpred,x0=np.squeeze(np.array(obj.hatx)));
#        obj.PREDT.append((cur_ts/3600+T.T)/24) # to day
#        obj.PREDCE.append(Y.T)
#        obj.HATX.append(obj.hatx.T)
#        
#        
#    def optimize_SP(obj,cur_ts,SPLs,SPUs,Ws,Rates): # YL,YU,W,R are matlab row vector -types
#        
#        hatx=obj.hatx
#		
#        if SPLs.shape!=(obj.Np,obj.p):
#            error()
#        if SPUs.shape!=(obj.Np,obj.p):
#            error()
#        if Ws.shape!=(obj.Np,obj.mw):
#            error()
#        if Rates.shape!=(obj.Np,obj.p):
#            error()
#        # Time series to vector form
##        YL=SPLs.reshape((SPLs.size,1),order='C') # scalar time series
##        YU=SPUs.reshape((SPUs.size,1),order='C')             
##        W=Ws.reshape((Ws.size,1),order='C')
##        R=Rates.reshape((Rates.size,1),order='C')
#
#        # averaging future info for blocking
##        YUblk=obj.Tr['yavg']*YU;
##        YLblk=obj.Tr['yavg']*YL;
##        Wblk=obj.Tr['wavg']*W;            
##        Rblk=obj.Tr['uavg']*R;
#
##        obj.iter=obj.iter+1  
##        
##        YLblks=YLblk.reshape((obj.Nblk,obj.p),order='C')
##        YUblks=YUblk.reshape((obj.Nblk,obj.p),order='C')
##        Rblks=Rblk.reshape((obj.Nblk,obj.m),order='C')
##        Wblks=Wblk.reshape((obj.Nblk,obj.mw),order='C')
##        
#        SPLblks=SPLs
#        SPUblks=SPUs
#        Wblks=Ws
#        Cblks=Rates
#        
#        # cvxpy =================================================
#        # Idea: givn r predict LOAD profile then calculate power
#        
#        x=cp.Variable((obj.n,obj.Nblk+1))# x(0)
#        r=cp.Variable((obj.mc,obj.Nblk)); # r[0]:=y(1), r[Np-1]=y(N)
#        vu=cp.Variable((1)) # general upperbound violation
#        vl=cp.Variable((1)) # general lowerbound violation
#        z=cp.Variable((1))  # demand target
#        
#        if obj.p!=obj.mc:
#            error('')
#            
#        # additional AHU variables
#        CL=cp.Variable((obj.p,obj.Nblk)) # cooling load (+)
#        
#        Pow=cp.Variable((obj.p,obj.Nblk)) 
#        
#        func=0
#        constr=[]
#        
#        for k in range(obj.Nblk):
#            # dynamic constraints
#            constr +=[ x[:,k+1]==obj.ablk*x[:,k]+obj.bcblk*r[:,k]+np.squeeze(np.array(obj.bwblk*Wblks[k,:].T)), 
#                       CL[:,k]== obj.cblk*x[:,k]+obj.dcblk*r[:,k]+np.squeeze(np.array(obj.dwblk*Wblks[k,:].T))]
#            
#            # temp bounds and demand constraints
#            constr +=[np.squeeze(np.array(SPLblks[k,:]))-vl<=r[:,k], # comfort lower viol
#                     r[:,k]<=np.squeeze(np.array(SPUblks[k,:]))+vu] # comfort upper viol
#            constr +=[Pow[:,k] <=z] # demand
#            
#            for iz in range(obj.p):
#                
#                # objective function
#                func +=Pow[iz,k]#significantly different behavior depending on objective function
#                
#                # physical constraints ============================S                
#                constr +=[Pow[iz,k] == Cblks[k,iz]*(CL[iz,k]), 
#                          CL[iz,k] >=0] # static HVAC map, Physical Var constraints
#                
#                
#        # time independent objective functiotns: demand, comfort violation    
#        func +=1e1*z +1e5*vu+1e5*vl
#        # time independent constraints: IC, demand and comfort violation 
#        constr += [x[:,0]==np.squeeze(np.array(obj.hatx)), 
#                   z >= 0, vl >= 0, vu >= 0]
#        problem = cp.Problem(cp.Minimize(func), constr)
#        problem.solve(solver=cp.GLPK,verbose=False)#cp.CVXOPT, solver=cp.ECOS,      
#        # cvxpy end =================================================
##            print('s:',s.value)
##            print('r:',r.value)
##            print('vu:',vu.value)
##            print('vl:',vl.value)
##            print('u:',u.value)
##            print('m:',m.value)
##            print('d:',d.value)
#        if problem.status in ['optimal', 'optimal_inaccurate']:
#            flag=1
#            SPk=np.mat(r[:,0].value) # to provide desired Q[0], I expect y[1]=r[1]
#            CLk=np.mat(CL[:,0].value)
#            
#            if obj.verbose: #SPk.T[0]>=1:
#                print(SPk.T, vu.value, vl.value)
#                print('uc:',CLk)
#            
#            
#            #analysis(obj,hatxk,UOPT,YU,YL,W,Rates)
#        else:
#            print(problem.status)
#            SPk=np.mat(r[:,0].value) # to provide desired Q[0], I expect y[1]=r[1]
#            CLk=np.mat(CL[:,0].value)
#            print(SPk.T, vu.value, vl.value)
#            error('no convergence??')
#        del problem
#        
#            
#            
#        #print('# CONTROL DECISION WAS MADE==================================================\
#        #===================================================================================') 
#        
#        
#        obj.OPTSP.append(SPk.T)
#        obj.predict_Np(cur_ts,r.value.T,Wblks)
#        return (SPk.T,CLk.T) #==============================
#
#    def analysis(obj):
#        close(302)
#        figure(302)
#        subplot(211)
#        ts=np.vstack(obj.MEASt)
#        N=len(obj.MEASt)
#        plot(ts/(24*3600),np.vstack(obj.MEASCE),'r',linewidth=3);grid(True)
#        for k in range(N):
#            if k%(3*2)==0:
#                plot(np.vstack(obj.PREDT)[k,:],np.vstack(obj.PREDCE)[k,:]);grid(True)
#        xlim([ts[0]/(24*3600),ts[-1]/(24*3600)])
#                
#        subplot(212)
#        pp.step(ts/(24*3600),np.vstack(obj.OPTSP),'r');grid(True)
#        plot(ts/(24*3600),np.vstack(obj.MEAST));grid(True)
#        xlim([ts[0]/(24*3600),ts[-1]/(24*3600)])
#            
##def obj_bd(obj,hatxk,YL,YU,W,R):
##    p1p2=np.kron(np.ones((1,obj.Nblk)),obj.Pmat0)
##    f=np.mat(np.array(R.T)*np.array(p1p2)) # [R1(1)P1(1), R2(1)P2(1), R1(2)P1(2), R2(2)P2(2)...]
##    ff=np.split(np.squeeze(np.array(f)),obj.Nblk) #(R1(1)P1(1), R2(1)P2(1)), (R1(2)P1(2), R2(2)P2(2)), ...
##    #f=np.squeeze(np.kron(R.T,obj.Pmat0))
### minimize R1(1)P1(1)*u1(1)+ R2(1)P2(1)*u2(1)+R1(2)P1(2)*u1(2)+R2(2)P2(2)u2(2)+ d + uviol + lviol
##    F=np.concatenate((f,np.mat(np.hstack((obj.w_on_d,1e2,1e2)))),1) # with demand cost comfort cost
###==============================================================================
### [P'u(1)  -d]<=0
### [P'u(2)  -d]<=0
### PU <=d            ==>  P U  -d       <=0
### Ox+MU<=Yu  +u     ==>  M U     -u     <= (YU -Ox-Mw*W)
### Yl-l<=Ox+MU       ==> -M U        -l  <= -(YL-Ox-Mw*W)
###==============================================================================
##    #Aie=np.concatenate((np.kron(np.mat(np.diag(np.asarray(R.T)[0])),obj.Pmat0),obj.Mc,-obj.Mc))
##    Aie=np.concatenate((PnP_subfunc.H_blk_diag(ff),obj.Mc,-obj.Mc))
##    
##    #Aie=np.concatenate((np.kron(np.eye(obj.Nblk),obj.Pmat0),obj.Mc,-obj.Mc))
##    Aie=np.concatenate((Aie,block_diag(-np.ones((obj.Nblk,1)),-np.ones((obj.Nblk*obj.p,1)),-np.ones((obj.Nblk*obj.p,1)))),1)
##    bie=np.concatenate((np.zeros((obj.Nblk,1)),YU-obj.Ob*hatxk-obj.Mw*W, -(YL-obj.Ob*hatxk-obj.Mw*W)))
##    ub =np.concatenate((np.tile(obj.ub0,(1,obj.Nblk)),np.mat(np.hstack((np.asscalar(100*obj.Pmat0*obj.ub0.T),100,100)))),1)
##    return (F,Aie,bie,ub)
#
#
#
##def H_shift(Y,ynewT):
##	if Y.shape[0]==1:
##		error('give me matlab like time series')
##	dumY=np.roll(Y,-1,0)
##	dumY[-1,:]=ynewT
##	YNEW=dumY
##	return YNEW
## [y1.T 		   [y2.T
##  y2.T		-> 		y3.T
##  y3.T				y4.T
##  y4.T]     		ynewT]
         
         
