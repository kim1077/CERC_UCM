#==============================================================================
# Data is obtained from Data_Cleaing
#==============================================================================
import os
from pandas import *
currentfolder='/home/adun6414/Work/CERC_UCM'
os.chdir(currentfolder)

close('all')
#mCW=read_csv('mCW.csv').set_index('Date')
#Weather=read_csv('Weather.csv').set_index('Date')
#PCT=read_csv('PCT.csv').set_index('Date')
#PCTtot=read_csv('PCTtot.csv').set_index('Date')
#PCH=read_csv('PCH.csv').set_index('Date')
#TCWS=read_csv('TCWS.csv').set_index('Date')
#TCWR=read_csv('TCWR.csv').set_index('Date')
#QCT_tot=read_csv('QCT_tot.csv').set_index('Date')
#TCHi=read_csv('TCHi.csv').set_index('Date')
#TCHe=read_csv('TCHe.csv').set_index('Date')
#TCHWSR=read_csv('TCHWSR.csv').set_index('Date')
#mCH_tot=read_csv('mCH_tot.csv').set_index('Date')
#mCH_totON=read_csv('mCH_totON.csv').set_index('Date')
#Qhat=read_csv('Qhat.csv').set_index('Date')
#QBL=read_csv('QBL.csv').set_index('Date')
#mr=read_csv('mr.csv').set_index('Date')
#ms_charge_hat=read_csv('ms_charge_hat.csv').set_index('Date')
#z=read_csv('z.csv').set_index('Date')
#Ts=read_csv('Ts.csv').set_index('Date')
filename='DATA8to8.csv'
#filename='DATA8to9.csv'
DATA=read_csv(filename).set_index('Date')
QBL=DATA['QBL'].fillna(method='ffill')
QCHL=DATA['QCHLsum'].fillna(value=0)
Twb=DATA['Twb'].fillna(method='ffill')
Pow=DATA[['PCHsum','PCTtot']].sum(axis=1)
figure(1)
ax=subplot(111)
QBL.apply(kW2ton).plot(grid=True ,ax=ax)
QCHL.apply(kW2ton).plot(grid=True ,ax=ax)
Pow.plot(grid=True,ax=ax)
legend(['QBL','QCHL','Pow'])
ylabel('ton,kW')
figure(2)
ax=subplot(111)
[k for k in DATA.keys() if 'm' in k]
DATA[['mcwsum','mCH_tot','mr','ms_char']].plot(grid=True)

figure(3)
DATA[['z']].plot(grid=True)




