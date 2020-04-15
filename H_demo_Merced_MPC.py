#==============================================================================
# demo for H_simobj
#==============================================================================
from matplotlib.pylab import *
from H_simobj import H_simobj
from H_utility import *
from numpy import *
import os
currentdir='/home/adun6414/Work/H_funclibpy'
## data loading
os.chdir('/home/adun6414/Work/CERC_UCM')hyh
filename='DATA8to8.csv'
#filename='DATA8to9.csv'
DATA=read_csv(filename).set_index('Date')
QBL=DATA['QBL'].fillna(method='ffill')
QCHL=DATA['QCHLsum'].fillna(value=0)
Twb=DATA['Twb'].fillna(method='ffill')
Pow=DATA[['PCHsum','PCTtot']].sum(axis=1)
os.chdir(currentdir)
modelname='Merced.CoolingPlantNew.Dummytest'
modelicafile='/home/adun6414/Work/CERC_UCM/Merced/CoolingPlantNew/Dummytest.mo'hhhhhhhhjjkp]
import pymodelica
import pyfmi
myfmu=pymodelica.compile_fmu(modelname,modelicafile)
fmuinpy=pyfmi.load_fmu(myfmu)
dt=30*60; # 30 min sampling time
start_time=6*30*24*3600    
final_time=start_time+1*24*3600
time=linspace(start_time,final_time,num=int((final_time-start_time)/dt))
time
IN=(['u'],)
#%% configuration file

testcase=2
if testcase==1:
    modelname='Merced.CoolingPlantNew.Chiller_Storage_Only_V2_MPC'
    modelicafile='/home/adun6414/Work/CERC_UCM/Merced/CoolingPlantNew/Chiller_Storage_Only_V2_MPC.mo'
elif testcase==2:
    modelname='Merced.CoolingPlantNew.Chiller_Storage_CoolingTower_V2_MPC'
    modelicafile='/home/adun6414/Work/CERC_UCM/Merced/CoolingPlantNew/Chiller_Storage_CoolingTower_V2_MPC.mo'

dt=30*60; # 30 min sampling time
start_time=6*30*24*3600    
final_time=start_time+1*24*3600

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
IN0=obj.simulate_schedule(x0_val,schedule)

#%%MPC configuration
from H_DP_Merced_Simple import H_DP_Merced_Simple

#obj.getidmodel(idmodel='CASE900Load1576283834') # unused in DP
obj.MPCsetup(MPCobj=H_DP_Merced_Simple,Npday=2) 
#Q: sampling time of simluation output is the same as control implementation period?
obj.does_local_follow_mpc(x0_val)
#%% MPC evaulation inputs: starts, final time, IC
#obj.evaluate_mpc(x0_val)
#obj.analysis_performance()