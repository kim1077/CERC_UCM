#==============================================================================
# %% MPC controller (algorithm: dynamic programming)
# % objective:  
# % constraints:
# algorithm
#==============================================================================
#import cvxpy as cp
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
import pandas as pd
from H_utility import *
from scipy.interpolate import *

class H_DP_Merced_Physical:
    def __init__(obj,MOD,Ts_hr,Np,Nblk,**varargindic):
        
       obj.Np=Np;
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
           obj.Cs=obj.rho*obj.V*obj.cv*(f2c(65)-f2c(40))# [kJ] worst case
           obj.Cs_tonhr=kJ2tonhr(obj.Cs)
           #obj.COP=;
       else:
           obj.V=pi*20**2*15
           obj.rho=1e3
           obj.cv=4.2 # kJ/kg-C
           obj.Cs=obj.rho*obj.V*obj.cv*(f2c(65)-f2c(40))# [kJ] worst case
           obj.Cs_tonhr=kJ2tonhr(obj.Cs)
           obj.COP=7;
       
       
       # define grid, x= z, Tsc, Tsh

       obj.ix_grid=[linspace(0.05,0.95,num=10),
                   linspace(f2c(35),f2c(40),3),
                    linspace(f2c(50),f2c(70),3)]  
       # define grid, u=TCHeSP, mCH
       obj.ju_grid=[linspace(f2c(35),f2c(45),num=3),
                   linspace(1e-3,gpm2kgs(3*1e3),num=10)]  
       obj.n=len(obj.ix_grid)
       obj.m=len(obj.ju_grid)
   
    def xcut(obj,xk):
        xbounds=xk
        for i in range(obj.n):
            xbounds[i]=min(max(xk[i],obj.ix_grid[i][0]),obj.ix_grid[i][-1])
        return xbounds.T.tolist()[0]
    def ucut(obj,uk):
        ubounds=uk
        for i in range(obj.m):
            ubounds[i]=min(max(uk[i],obj.ju_grid[i][0]),obj.ju_grid[i][-1])
        return ubounds.T.tolist()[0]

    def f(obj,xk,uk,wk):
        QBL=wk[0]
        ER=wk[1]
        PnonHVAC=wk[2]
        Psolarpv=wk[3]
        mr=max(wk[4],1e-3)
        
        z=xk[0]
        Tsc=xk[1]
        Tsh=xk[2]
        
        TCHe=uk[0]
        mCH=uk[1]
        
        Tr=f2c(40)+QBL/(mr*obj.cv)        
        Cv0=obj.rho*obj.V*obj.cv
        zh=1-z
        
        if mCH>=mr:
            zp1=z+(mCH-mr)*obj.Ts/(obj.rho*obj.V)
            #Cv0*Tsc*(zp1-z) +Cv0*(Tscp1-Tsc)*z    =+(mCH-mr)*obj.cv*TCHe*obj.Ts
            #Cv0*Tsh*(-zp1+z)+Cv0*(Tshp1-Tsh)*(1-z)=-(mCH-mr)*obj.cv*Tsh *obj.Ts
            
            Tscp1=Tsc+((mCH-mr)*obj.cv*TCHe*obj.Ts)/(Cv0*z) -Tsc*(zp1-z)/z
            #Tshp1=Tsh-((mCH-mr)*obj.cv*Tsh *obj.Ts)/(Cv0*zh)-Tsh*(-zp1+z)/zh
            Tshp1=Tsh
            
            
        else:
            zp1=z+(mCH-mr)*obj.Ts/(obj.rho*obj.V)
            #Cs*Tsc*(zp1-z) +Cs*(Tscp1-Tsc)*z    =+(mCH-mr)*obj.cv*Tsc*obj.Ts
            #Cs*Tsh*(-zp1+z)+Cs*(Tshp1-Tsh)*(1-z)=-(mCH-mr)*obj.cv*Tr *obj.Ts
             
            Tscp1=Tsc+((mCH-mr)*obj.cv*Tsc*obj.Ts)/(Cv0*z) -Tsc*(zp1-z)/z
            Tshp1=Tsh
            #Tshp1=Tsh-((mCH-mr)*obj.cv*Tr *obj.Ts)/(Cv0*zh)-Tsh*(-zp1+z)/zh
            
        xkp1=mat(vstack((zp1,Tscp1,Tshp1)))
#        print 'xk', xk.T, 'uk', uk.T 
#        print 'xkp1', xkp1.T , 'mCH-mr', mCH-mr        
 
        return xkp1
    
    def g_feasible(obj,xk,uk,wk,xkp1):
        # h(x)=0
        # g(x)<=0
        # wk=Building load, price schedule, nonHVACP, Psolargen
        z=xk[0]
        TCHe=uk[0]
        mCH=uk[1]
        
        QCHL=obj.Transform(xk,uk,wk)
            
        zp1=xkp1[0] 
        #QCHL=QBL0-
        # note stage bounds aren't applied to this
        constraints=  [0.1<=zp1, zp1<=0.9,
                      f2c(34)<=TCHe, TCHe<=f2c(50), 0<=mCH, mCH<=gpm2kgs(3*1e3), 
                      QCHL>=0, QCHL<=ton2kW(3*1e3)]
             #      ( QDIS <= ton2kW(1e3)+ 0*gpm2kgs(2000)*obj.cv*(f2c(50)-f2c(40)) ),
             #      (-QDIS <= ton2kW(1e3) + 0*gpm2kgs(2000)*obj.cv*(f2c(50)-f2c(40)) ),
             #      (QCHL>=0) & (QCHL<=ton2kW(1e3))
        # print constraints, all(constraints)
        feasible=all(constraints)
        return feasible
    
    def phi(obj,xk,uk,wk):
        
        ER=wk[1]
        PnonHVAC=wk[2]
        Psolarpv=wk[3]
        QCHL=obj.Transform(xk,uk,wk)
        
        COP=obj.COP
        stagecost=ER*max(1./COP*QCHL+PnonHVAC-Psolarpv,0);
        return stagecost
    
    
    def M(obj,xk):
        Miercost=mat([0.]);
        return Miercost


    def BellmanEq(obj,Ws):
        ix_grid=obj.ix_grid
        ju_grid=obj.ju_grid
        N=obj.Np
        n=obj.n    
        m=obj.m
        # specify number of grid vector for x
        ngrid_x=zeros(n)
        for i in range(n):
            ngrid_x[i]=len(ix_grid[i])
        ngrid_x=ngrid_x.astype(int)
    
        ngrid_u=zeros(m)
        for j in range(m):
            ngrid_u[j]=len(ju_grid[j])
        ngrid_u=ngrid_u.astype(int)
    
    
        Vok=list() # Vok[k](x1,x2,...) : (R*R*R*...) --> R
        for k in range(N+1):
            if k is N:
                dummy=0.*ndarray(ngrid_x)
                for x_ndinx in ndindex(tuple(ngrid_x)):
                    xk=mat(zeros((n,1)))
                    for i in range(n): # just define x vector as a "k"th node according to an python-defined index on x-grid
                        xk[i]=ix_grid[i][x_ndinx[i]] #=X[i][x_ndinx] << e.g. (2,3). find the 2nd, i.e the first x_ndix, element of the grid for the "ith" x
                    dummy[x_ndinx]=obj.M(xk)        
                    
                Vok.append(dummy);   # Terminal cost at x (x,N)
            else:    
                Vok.append(nan*ndarray(ngrid_x));   # Optimal cost to go from k to N at x (x,k)|--> V*(x,k) in R
        Uok=list()
        for j in range(m):
            Ujok=list() # Uok[time=k][input number=j](x1,x2,..)--> (u1,u2,...)
            for k in range(N):    
                Ujok.append(nan*ndarray(ngrid_x));   # Optimal input map (x,k)|--> uk that is u*(x,k) in Rm
            Uok.append(Ujok) # repeat list of the list which is Ujok
        
        for kb in range(1,N+1):
            wk=mat(Ws[N-kb,:]).T
            for x_ndinx in ndindex(tuple(ngrid_x)): # x_ndinx = n-dimensional index of ndgrid, e,g, (2,3,4)
                
                xk=mat(zeros((n,1)))
                for i in range(n): # just define x vector as a "k"th node according to an python-defined index on x-grid
                    xk[i]=ix_grid[i][x_ndinx[i]] #=X[i][x_ndinx] << e.g. (2,3). find the 2nd, i.e the first x_ndix, element of the grid for the "ith" x
                dummy=1e10;   # initital estimation of optitmal cost to go from k to N given xi
                #print(xk.T)                        
                Vkp1funcofx=RegularGridInterpolator(ix_grid,Vok[N-kb+1],bounds_error=False);#method='nearest')
                for u_ndinx in ndindex(tuple(ngrid_u)): # just define u vector as a "u"th node according to an python-defined index on u-grid
                    uk=nan*mat(zeros((m,1)))
                    for j in range(m):
                        uk[j]=ju_grid[j][u_ndinx[j]] ## e.g.(3,4), find the 3rd (=1st u_ndinx) element of the jth u-grid
                    
                    xkp1=obj.f(xk,uk,wk);# next state
                    if obj.g_feasible(xk,uk,wk,xkp1):
                        #print xkp1.T, obj.xcut(xkp1)
                        Vokp1xp1=Vkp1funcofx(obj.xcut(xkp1))
                        # Vokp1xp1=interpn(ix_grid,Vok[N-kb+1],xkp1.T.tolist()[0],bounds_error=False,fill_value=1e10); # optimal cost to go from k+1 to N at xkp1
                        # Note it is a known function, e.g. terminal cost if kb=1
                        Vkxu=obj.phi(xk,uk,wk)+Vokp1xp1; # a cost from k to N at xi with uj 
                        #print 'updated', 'xk', xk.T, 'uk', uk.T, 'xkp1', xkp1.T, 'phi', obj.phi(xk,uk,wk), 'Vokp1xp1', Vokp1xp1
                    else: # infeasible
                        Vkxu=1e10
                    
                    
                    if Vkxu<dummy:
                        dummy=Vkxu;
                        
                        for j in range(m):
                            Uok[j][N-kb][x_ndinx]=uk[j];
                
                    Vok[N-kb][x_ndinx]=dummy;
                #print 'opt', uk.T
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
        x=nan*random.random((obj.Np+1,obj.n))
        UTR=nan*random.random((obj.Np,obj.m))
        phik=nan*random.random((obj.Np,1))
        QCHL=nan*random.random((obj.Np,1))
        x[0,:]=x0.T;
        T=arange(0,obj.Np+1,1)
        for k in range(obj.Np):
            wk=W[k,:].T
            for j in range(obj.m):
                Uoptfuncofx=RegularGridInterpolator(obj.ix_grid,Uok[j][k],bounds_error=False)
                UTR[k,j]=Uoptfuncofx(obj.xcut(mat(x[k,:]).T));
            x[k+1,:]=   obj.f(mat(x[k,:]).T,mat(UTR[k,:]).T,wk).T
            phik[k]=obj.phi(mat(x[k,:]).T,mat(UTR[k,:]).T,wk)
            QCHL[k]=obj.Transform(mat(x[k,:]).T,mat(UTR[k,:]).T,wk)
            
        if len(varargin) is not 0:
            figure(2)
            subplot(211)
            plot(T,x[:,0],'o-');grid(True);
            ylabel('state of charge [%]')            
            title('MPCthink')
            subplot(212)
            pp.step(T[:-1],kgs2gpm(UTR[:,1]),'-o',where='post');#ylim([-1,1.5])
            ylabel('optimal gpm')
            grid(True)
            figure(3)
            subplot(211)
            plot(T[:-1],hstack((kW2ton(H_iscolumn(W[:,0])),kW2ton(QCHL))),'-o')
            legend(['QBL','QCHL'])
            ylabel('ton')            
            title('MPCthink')
            grid(True)
            print phik.shape
            subplot(212)
            plot(T[:-1],hstack((H_iscolumn(QCHL/obj.COP),H_iscolumn(W[:,3]))),'-o')
            legend(['P_{HVAC}','P_{solar}']);
            ylabel('kW')
            xlabel('hour')
            grid(True)
            
        print phik.sum()
        return UTR, phik.sum()
        
    def Transform(obj,xk,uk,wk):
        QBL=wk[0]
        ER=wk[1]
        PnonHVAC=wk[2]
        Psolarpv=wk[3]
        mr=max(wk[4],1e-3)
        
        z=xk[0]
        Tsc=xk[1]
        Tsh=xk[2]
        
        TCHe=uk[0]
        mCH=uk[1]
        
        Tr=f2c(40)+QBL/(mr*obj.cv)
                
        if mCH>mr: # charge: cold in hot out
            Tmix=(mCH-mr)/mCH*Tsh+mr/mCH*Tr
        else:
            Tmix=Tr
        QCHL=mCH*obj.cv*(Tmix-TCHe)
        return QCHL
        
        
            
#%% test object
if __name__ is '__main__':
    import scipy.signal
    close('all')
    MOD=list()
    Ts_hr=1.;
    Np=2*24;
    Nblk=Np;
    obj=H_DP_Merced_Physical(MOD,Ts_hr,Np,Nblk)
    T=arange(0,(Np+1)*Ts_hr*3600,3600)
    W=hstack((filtfilt(3,H_schedule(T[:-1],[7,19],ton2kW(1.5*1e3),0)), #BL
              H_schedule(T[:-1],[7,19],3,1),   # price
              filtfilt(3,H_schedule(T[:-1],[7,19],0*1000,0)),  # PnonHVAC
              filtfilt(3,H_schedule(T[:-1],[10,15],0*1300,0)), #Psolar
              filtfilt(3,H_schedule(T[:-1],[7,19],gpm2kgs(1.5*1e3),0)))) # mreturn 
    # Building load, price schedule, nonHVACP, Psolargen, mr
    
    x0=mat([0.2, f2c(40), f2c(40)+5]).T # z, Tc, Th
    import time
    tic=time.time()
    #(Vok,Uok)=obj.BellmanEq(W)
    totalcost=obj.controller(x0,W,'show')        
    toc=time.time()
    print toc-tic, 'sec'
         
