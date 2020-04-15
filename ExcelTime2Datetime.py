def xldate_to_datetime(excel_time):
    number_of_days_from_19000101=excel_time
    temp = datetime.datetime(1899, 12, 30)
    return temp+datetime.timedelta(number_of_days_from_19000101)# timedelta: number of days in R --> datetime obj

import os
from pandas import *
import datetime

#%% for debug
os.chdir('/home/adun6414/Work/CERC_UCM/RawData/H_extracted/d2018/combined')
filename=os.listdir(os.getcwd())
print 'file name: ', filename[0]
data=read_csv(filename[0])
print 'time in csv:',data.Date[0:2]
ts=Timestamp(data.Date[0],tz='US/Pacific').timestamp()
print 'timestamp corresponding the time index  in csv', ts

print 'excel time:', data['Excel Time'].values[0]
print 'excel time to datetime format', xldate_to_datetime(data['Excel Time'].values[0])


#%%validation
import numpy as np

for k in range(10):
    print '=============================================='
    i=int(data.shape[0]*np.random.random(1))
    exceltime=data['Excel Time'].values[i]
    hat_datetime=xldate_to_datetime(exceltime)
    print 'datetime estimation:', hat_datetime
    print 'true:', data['Date'].values[i]
    