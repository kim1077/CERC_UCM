#==============================================================================
# demo for H_simobj
#==============================================================================
from matplotlib.pylab import *
from H_simobj import H_simobj
from H_utility import *
from numpy import *
import os

currentdir='/home/adun6414/Work/CERC_UCM'

dt=30*60; # 30 min sampling time
start_time=H_date2simtime(to_datetime('2018-08-01 00:00'),'2018')
final_time=H_date2simtime(to_datetime('2018-08-07 00:00'),'2018')
simtimes=arange(start_time,final_time,dt)
simtimedate=date_range(start=H_simtime2date(start_time,'2018'),end=H_simtime2date(final_time,'2018'),freq=str(int(30*60./60))+'T')

## data loading and resampling
os.chdir('/home/adun6414/Work/CERC_UCM/Fig_n_data')
filename='DATA8to8.csv' #filename='DATA8to9.csv'
DATARAW=read_csv(filename).set_index('Date')
DATARAW=DATARAW.set_index(to_datetime(DATARAW.index)) # change 'str' to datetime obj
DATARAW['time']=H_date2simtime(DATARAW.index,'2018')
DATA=DATARAW.reindex(simtimedate,method='nearest') # resample or reindex
QBL=DATA[['QBL','time']].fillna(method='ffill')
QCHL=DATA[['QCHLsum','time']].fillna(value=0)
Twb=DATA[['Twb','time']].fillna(method='ffill')
Pow=DATA[['PCHsum','PCTtot','time']].sum(axis=1)
del DATARAW, DATA
os.chdir(currentdir)

#%% modelica model test
modelname='Merced.CoolingPlantNew.Dummytest'
modelicafile='/home/adun6414/Work/CERC_UCM/Merced/CoolingPlantNew/Dummytest.mo'
import pymodelica
import pyfmi
myfmu=pymodelica.compile_fmu(modelname,modelicafile)
fmuinpy=pyfmi.load_fmu(myfmu)

UW=fmuinpy.get_model_variables(causality=0)
Y=fmuinpy.get_model_variables(causality=1)
C=fmuinpy.get_model_variables(variability=1)

key_uw=UW.keys()
key_y=Y.keys()
key_c=[k for k in C.keys() if '_' not in k]

IN=(obj.key_uw[0],QBL[['time','QBL']].to_numpy())

opts = fmuinpy.simulate_options()
opts["ncp"] = IN[1].shape[0]-1 #Specify a number of output points that should be returned
res0=fmuinpy.simulate(start_time=QBL['time'][0],final_time=QBL['time'][-1],input=IN,options=opts)
figure(2)
plot(res0['time'],res0[obj.key_uw[0]],'o-')
plot(res0['time'],res0[obj.key_y[0]],'*-')