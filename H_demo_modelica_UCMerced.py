# -*- coding: utf-8 -*-
"""
Created on Mon Oct 14 10:08:03 2019

@author: adun6414
"""
import pymodelica
from pandas import *
from matplotlib.pyplot import *
from numpy import *
from scipy import *
casenum=3

close('all')
if casenum==1:
    modelname='Merced.CoolingPlantNew.Chiller_Only'
    modelicafile='/home/adun6414/Work/CERC_UCM/Merced/CoolingPlantNew/Chiller_Only.mo'
    start_time=6*30*24*3600    
    final_time=start_time+1*24*3600
    keyT=['Sensor_TCHWS.T','Sensor_TCHWR.T','Sensor_msup.m_flow','time']
elif casenum==2:
    modelname='Merced.CoolingPlantNew.Chiller_Storage_Only_V2'
    modelicafile='/home/adun6414/Work/CERC_UCM/Merced/CoolingPlantNew/Chiller_Storage_Only_V2.mo'
    start_time=6*30*24*3600    
    final_time=start_time+1*24*3600
    keyT=['Sensor_TCHWS.T','Sensor_TCHWR.T','Sensor_msup.m_flow','Sensor_mCHi.m_flow','Sensor_mS.m_flow','time',
          'Sensor_Tstorage[1].y','Sensor_Tstorage[2].y','Sensor_Height[1]','Sensor_Height[2]','Sensor_Height[3]']
elif casenum==3:
    modelname='Merced.CoolingPlantNew.Chiller_Storage_CoolingTower'
    modelicafile='/home/adun6414/Work/CERC_UCM/Merced/CoolingPlantNew/Chiller_Storage_CoolingTower.mo'
    start_time=6*30*24*3600    
    final_time=start_time+1*24*3600
    keyT=['Sensor_TCHWS.T','Sensor_TCHWR.T','Sensor_msup.m_flow','Sensor_mCHi.m_flow','Sensor_mS.m_flow','time',
          'Sensor_Tstorage[1].y','Sensor_Tstorage[2].y','Sensor_Height[1]','Sensor_Height[2]','Sensor_Height[3]']
     

myfmu=pymodelica.compile_fmu(modelname,modelicafile,target='me',version='2.0')
import pyfmi
fmuinpy=pyfmi.load_fmu(myfmu)
opt=fmuinpy.simulate_options()
res=fmuinpy.simulate(start_time=start_time,final_time=final_time,options=opt)
#
#del myfmu
#del fmuinpy

dataT=DataFrame(columns=keyT)
for k in keyT:
    dataT[k]=res[k]
dataT.index=dataT.time
dataT.plot(x='time',y=[k for k in keyT if '.m_flow' in k])
dataT.plot(x='time',y=[k for k in keyT if '.T' in k])
dataT.plot(x='time',y=[k for k in keyT if 'Height' in k])
#dataT.plot(x='time',y=[k for k in keyT if '.mA' in k or '.mB' in k])
#dataT.plot(x='time',y=[k for k in keyT if '.U' in k])


    