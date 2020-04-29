#!/usr/bin/env python
# coding: utf-8

# In[1]:


from __future__ import print_function
from pandas import *
import numpy as np
from numpy import *
from matplotlib.pyplot import *
from drawnow import drawnow, figure
import scipy as sp
from H_utility import *
import scipy.signal
from H_DP_Merced_Simple import H_DP_Merced_Simple


# In[3]:
Qtonmax=3000
MOD=list()
Ts_hr=1;
Np=1*24;Nblk=Np;

T=arange(0,7*24*3600,3600)

W=hstack((filtfilt(3,H_schedule(T[:-1],[7,19],ton2kW(1.5*1e3),0)), #BL
          H_schedule(T[:-1],[7,19],3,1),   # price
          filtfilt(3,H_schedule(T[:-1],[7,19],0*1000,0)),  # PnonHVAC
          filtfilt(3,H_schedule(T[:-1],[10,15],0*2000,0)))) #Psolar

obj=H_DP_Merced_Simple(MOD,Ts_hr,Np,Nblk,Qtonmax=Qtonmax)
x0=0.5
cur_t=0

# functional tests for some senarios
obj.exeMPC(cur_t,x0,W[:Np,:],wannaplot=True)
#savefig('meeting_UCM_MPC.png')

# In[3]:
Qtonmax=3000
W=hstack((filtfilt(3,H_schedule(T[:-1],[7,19],ton2kW(1.5*1e3),0)), #BL
          H_schedule(T[:-1],[7,19],3,1),   # price
          filtfilt(3,H_schedule(T[:-1],[7,19],0*1000,0)),  # PnonHVAC
          filtfilt(3,H_schedule(T[:-1],[10,15],1*2000,0)))) #Psolar

obj=H_DP_Merced_Simple(MOD,Ts_hr,Np,Nblk,Qtonmax=Qtonmax)
x0=0.5
cur_t=0

# functional tests for some senarios
obj.exeMPC(cur_t,x0,W[:Np,:],wannaplot=True)
#savefig('meeting_UCM_.png')





