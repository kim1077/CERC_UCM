import os

currentfolder='/home/adun6414/Work/CERC_UCM'
os.chdir(currentfolder)

from Data_Unzip import *

wannasave=False
#%% unzip and get raw_dataframe
    
wanna_re_unzip=0
data=Unzip_all(wanna_re_unzip)
os.chdir(currentfolder)

#%% cleaning data (sampling time match, calculate right Q,T,P,m ...
from numpy import *
from H_utility import *

#%% condensor water flow rate is constantly controlled.
startdate='2018-08-01 00:00'
enddate='2018-08-06 23:45'#'2019-08-3' 
dates=date_range(start=startdate,end=enddate,freq='15T')
DATA=DataFrame(index=dates)
DATA.index.name='Date'
# close('all')

mCW=data['mCW'][startdate:enddate].resample('15T').mean().apply(gpm2kgs) # gpm???
mCW.columns=['mcw1','mcw2','mcw3','mcw4','mcw5']

mCW[mCW>gpm2kgs(300)].apply(kgs2gpm).hist(bins=100,alpha=0.5)
title('CW [gpm?]')
if wannasave:
    savefig('mCWpgm.png')
mCWscale=mCW/mCW.dropna().max()
mCW['mcwsum']=mCW.sum(axis=1)

figure()
mCW['mcwsum'].apply(kgs2gpm).plot()
title('mCT total [gpm?]')
if wannasave:
    savefig('mCT_tot_gpm.png')

DATA=DATA.merge(mCW,how='outer',on='Date') # append data

#%% weather data
#Toa=data['Toa'][startdate:enddate].resample('15T').mean()
Toa=data['Toa'][startdate:enddate].reindex(dates,method='nearest')

#RH=data['RH'][startdate:enddate].resample('15T').mean()
RH=data['RH'][startdate:enddate]
RH=RH[~RH.index.duplicated()]
RH=RH.reindex(dates,method='nearest')

Weather=Toa.merge(RH,on='Date',how='inner')
Weather.columns=['Toa','RH']
Weather=Weather.dropna()
from CoolProp.HumidAirProp import HAPropsSI
Twb = HAPropsSI('B','T',Weather.iloc[:,0].to_numpy()+273.15,'R',Weather.iloc[:,1].to_numpy()*1./100,'P',101325) #HumRat(AirH2O,T=T_a_in , P=p_atm,B=T_wb_in ) "lbm/lbm"                "Humidity ratio"
Weather['Twb']=k2c(Twb)
#for k in range(Weather.shape[0]):
#    try:
#        Twb = HAPropsSI('B','T',Weather.iloc[k,0].to_numpy()+273.15,'R',Weather.iloc[k,1].to_numpy()*1./100,'P',101325) #HumRat(AirH2O,T=T_a_in , P=p_atm,B=T_wb_in ) "lbm/lbm"                "Humidity ratio"
#    except:
#        Twb = np.NaN


DATA=DATA.merge(Weather,how='outer',on='Date')

#%% Cooling Tower Power, What is kW (1), kW(2), kW(3) ????
PCT=data['PCT'][startdate:enddate].resample('15T').mean()
PCT[[k for k in PCT.columns.to_list() if 'Power' in k]].plot()
PCTtot=PCT[[k for k in PCT.columns.to_list() if 'Power' in k]].sum(axis=1).to_frame('PCTtot')

PCT.plot()
title('PCT')

figure()
PCTtot.plot()
title('PCT')
if wannasave:
    savefig('PCT_total_kW.png')
    
DATA=DATA.merge(PCTtot,how='outer',on='Date')
#%% check it is exactly correlated with chiller operation

PCH=data['PCH_kW'][startdate:enddate].resample('15T').mean()
PCH['PCHsum']=PCH.sum(axis=1)
#PCH[PCH>0].iloc[:,0:5].plot.hist(bins=30,alpha=0.5)
# 1. whenever 4 is activated, 5 is activated and none of 1,2,3 are activated.
ON=DataFrame()
ONPLOT=DataFrame()
mCWPLOT=DataFrame()
for i in range(1,6):
    ON[str(i)]=1*(PCH[enum('P',i)]>10)
    ONPLOT[str(i)]=1*(PCH[enum('P',i)]>10)+i-1
#    mCWPLOT[str(i)]=mCWscale[str(i)]+i-1
    
fig,ax=subplots(1,1)
ONPLOT.plot(ax=ax)
#mCWPLOT.plot(ax=ax)
#if wannasave:
#    savefig('data_mCW_PCHON.png')

DATA=DATA.merge(PCH,how='outer',on='Date')
#%% TCW, 1,2,3 are named correctly but 4,5 are opposite
TCWS=data['TCWS'][startdate:enddate].resample('15T').mean()
TCWR=data['TCWR'][startdate:enddate].resample('15T').mean()


figure()
for i in range(1,6):
    ax=subplot(5,1,i)
    TCWS[enum('TCWS',i)].plot(ax=ax,style='.-')
    TCWR[enum('TCWR',i)].plot(ax=ax,style='.-')
    legend(['TCWS','TCWR'])
    grid(True)

#% rename data
TCW=TCWS.merge(TCWR,on='Date')
TCWS=DataFrame()
TCWR=DataFrame()

for i in range(1,6):
    if i<4:
        TCWS[str(i)]=TCW[enum('TCWS',i)]
        TCWR[str(i)]=TCW[enum('TCWR',i)]
    else:
        TCWS[str(i)]=TCW[enum('TCWR',i)]
        TCWR[str(i)]=TCW[enum('TCWS',i)]
        
figure()
for i in range(1,6):
    ax=subplot(5,1,i)
    TCWS[str(i)].plot(ax=ax,style='.-')
    TCWR[str(i)].plot(ax=ax,style='.-')
    legend(['TCWS','TCWR'])
    grid(True) 
    
renamedTCWS=TCWS.copy()
renamedTCWR=TCWR.copy()
renamedTCWS.columns=['TCWS'+str(k+1) for k in range(5)]
renamedTCWR.columns=['TCWR'+str(k+1) for k in range(5)]
DATA=DATA.merge(renamedTCWS,how='outer',on='Date')
DATA=DATA.merge(renamedTCWR,how='outer',on='Date')

#%% cooling tower capacity [kW]
dum=DataFrame()
dum['TCWS']=TCWS.mean(axis=1).apply(f2c)
dum['TCWR']=TCWR.mean(axis=1).apply(f2c)
dum['mCW']=mCW['mcwsum']
QCT_tot=dum['mCW']*4.2*(dum['TCWR']-dum['TCWS'])
QCT_tot=QCT_tot.to_frame('QCT_tot')
figure()
QCT_tot.apply(kW2ton).plot()
title('QCT_tot_ton')
DATA=DATA.merge(QCT_tot,how='outer',on='Date')

#%% TCHWS & R , 4 is opposite
TCHi=data['TCHi'][startdate:enddate].resample('15T').mean()
TCHe=data['TCHe'][startdate:enddate].resample('15T').mean()
figure()
for i in range(1,6):
    ax=subplot(5,1,i)
    TCHi[enum('TCHi',i)].plot(ax=ax,style='.-')
    TCHe[enum('TCHe',i)].plot(ax=ax,style='.-')
    legend(['TCHi','TCHe'])
    grid(True)
#% rename data
TCHW=TCHi.merge(TCHe,on='Date')
TCHi=DataFrame()
TCHe=DataFrame()

for i in range(1,6):
    if i!=4: 
        TCHi[str(i)]=TCHW[enum('TCHi',i)]
        TCHe[str(i)]=TCHW[enum('TCHe',i)]
    else:
        TCHi[str(i)]=TCHW[enum('TCHe',i)]
        TCHe[str(i)]=TCHW[enum('TCHi',i)]    
figure()
for i in range(1,6):
    ax=subplot(5,1,i)
    TCHi[str(i)].plot(ax=ax,style='.-')
    TCHe[str(i)].plot(ax=ax,style='.-')
    legend(['TCHi','TCHe'])
    grid(True)


renamedTCHi=TCHi.copy()
renamedTCHe=TCHe.copy()
renamedTCHi.columns=['TCHi'+str(k+1) for k in range(5)]
renamedTCHe.columns=['TCHe'+str(k+1) for k in range(5)]
DATA=DATA.merge(renamedTCHi,how='outer',on='Date')
DATA=DATA.merge(renamedTCHe,how='outer',on='Date')

#%% mass flow rate 
# close('all')
dd=data['TCHS_n_TCHR'][startdate:enddate].resample('15T').mean()
TCHWSR=dd[['Chilled Water Supply','Chilled Water Return']]
mflow=dd[['CHW Flow (gpm)',
       u'CHW Total Sec GPM', 
       u'Primary CHWR Temp', 
       u'Primary CHWS Flow To TES',
       u'Primary CHWS Flow']]
# distribution of mflow when the  flow is over than 5000 gpm
mCH_tot=mflow['Primary CHWS Flow'] #gpm
mCH_tot[mCH_tot>5000]=0.5*mCH_tot[mCH_tot>5000]   
mCH_tot=mCH_tot.apply(gpm2kgs).to_frame()
mCH_totON=mCH_tot.merge(ON,on='Date')


figure()
mflow['Primary CHWS Flow'].plot(style='.-');grid(True);ylabel('gpm')

if wannasave:
    savefig('data_mgpm.png') 
#check flow is consistent with power on off
figure()
ONPLOT.plot()
#(mCH_tot/max(mCH_tot.dropna())*6).plot()

DATA=DATA.merge(TCHWSR,how='outer',on='Date')
DATA=DATA.merge(mflow,how='outer',on='Date')
renamed_mCH_tot=mCH_tot.copy()
renamed_mCH_tot.columns=['mCH_tot']
DATA=DATA.merge(renamed_mCH_tot,how='outer',on='Date')


#%% split mCHtotal to each mCH

for i in range(1,6):
    mCH_totON[str(i)]=multiply(mCH_totON[str(i)],mCH_totON['Primary CHWS Flow'])    

Qhat=DataFrame()
for i in range(1,6):
    Qhat[str(i)]=multiply(4.2*mCH_totON[str(i)], TCHi[str(i)].apply(f2c)-TCHe[str(i)].apply(f2c))
figure()
for i in range(1,6):
    ax=subplot(5,1,i)
    Qhat[str(i)].apply(kW2ton).plot(ax=ax)
    #QCHLkW[enum('Q',i)].plot(ax=ax,style='r')

if wannasave:
    savefig('data_QkW.png') 
    
renamedQhat=Qhat.copy()
renamedQhat.columns=['QCHL'+str(k+1) for k in range(5)]
renamedQhat['QCHLsum']=renamedQhat.sum(axis=1)
DATA=DATA.merge(renamedQhat,how='outer',on='Date')
#Qhat=mCH*4.2*(TCHi-TCHe)
#Rawdata_CH={'index':mCH_totON.index,'mCH_totON':mCH_totON.to_numpy(), 'Qhat':Qhat.to_numpy(), 'PkWiCH':PkWiCH.to_numpy(),'TCHe':TCHe.to_numpy(),'TCHi':TCHi.to_numpy(),'TCWS':TCWS.to_numpy(),'TCWR':TCWR.to_numpy()}
#sp.io.savemat('Rawdata_CH',Rawdata_CH)
#%% building load plot
# delta T ? plot(TCHWSR['Chilled Water Return'].apply(f2c)-TCHWSR['Chilled Water Supply'].apply(f2c))
Cp=4.2;
mrgpm=mflow['CHW Total Sec GPM']
mr=mrgpm.apply(gpm2kgs).to_frame('mr')
QBLton=(mflow['CHW Total Sec GPM'].apply(gpm2kgs)*Cp*(TCHWSR['Chilled Water Return'].apply(f2c)-TCHWSR['Chilled Water Supply'].apply(f2c))).apply(kW2ton)
QBL=QBLton.apply(ton2kW).to_frame('QBL')
QBLton.plot()
mrgpm.plot()
grid(True)

DATA=DATA.merge(mr,how='outer',on='Date')
DATA=DATA.merge(QBL,how='outer',on='Date')
#%% storage data
ms_charge=mflow['Primary CHWS Flow To TES'].apply(gpm2kgs).to_frame('ms_charge')
z=data['z'][startdate:enddate].resample('15T').mean()
z.columns=['z']
#% mass balance ms_charge doesn't make any sense!!!
figure()
fig,ax=subplots(1,1)
mCH_tot.apply(kgs2gpm).plot(ax=ax,style='b')
mr.apply(kgs2gpm).plot(ax=ax,style='r')
ms_charge.apply(kgs2gpm).plot(ax=ax,style='k')

mCH_tot=mCH_tot.fillna(value=0)
ms_charge_hat=subtract(mCH_tot,mr)
ms_charge_hat.columns=['ms_char']
figure()
fig,ax=subplots(1,1)
(ms_charge_hat.apply(kgs2gpm)/3000).plot(ax=ax)
(0.01*z).plot(ax=ax)
grid(True)
if wannasave:
    savefig('z_mflow.png')
#data['mCH_n_mr'].plot()


DATA=DATA.merge(ms_charge_hat,how='outer',on='Date')
DATA=DATA.merge(z,how='outer',on='Date')
#%% storage temperatre
T1=data['Ts1328'][startdate:enddate].resample('15T').mean()
T2=data['Ts2944'][startdate:enddate].resample('15T').mean()
Ts=T1.merge(T2,on='Date',how='inner')
T3=data['Ts4556'][startdate:enddate].resample('15T').mean()
Ts=Ts.merge(T3,on='Date',how='inner')

#%
figure(1000)
ax=subplot(2,1,1)
QBLton.plot(ax=ax)
Qhat.sum(axis=1).apply(kW2ton).plot(ax=ax)
QCT_tot.apply(kW2ton).plot(ax=ax)
PCTtot.plot(ax=ax)
PCH['PCHsum'].plot(ax=ax)
grid(True)
legend(['QBL','QCHL','QCT','PCT','PCH'])

ax=subplot(2,1,2)
(0.01*z).plot(ax=ax)
grid(True)
if wannasave:
    savefig('Final.png')
DATA=DATA.merge(Ts,how='outer',on='Date')

#%% save all variables
DATA.to_csv(
'DATA'+str(Timestamp(startdate).month)+'to'+str(Timestamp(enddate).month)+'.csv',header=True)
#var_name=['mCW','Weather', 'PCT', 'PCTtot', 'PCH', 'TCWS','TCWR','QCT_tot','TCHi','TCHe',
#          'TCHWSR','mCH_tot','mCH_totON','Qhat','QBL', 'mr', 'ms_charge_hat','z','Ts']
#mCW.to_csv('mCW.csv',header=True)
#Weather.to_csv('Weather.csv',header=True)
#PCT.to_csv('PCT.csv',header=True)
#PCTtot.to_frame().to_csv('PCTtot.csv',header=True)
#PCH.to_csv('PCH.csv',header=True)
#TCWS.to_csv('TCWS.csv',header=True)
#TCWR.to_csv('TCWR.csv',header=True)
#QCT_tot.to_csv('QCT_tot.csv',header=True)
#TCHi.to_csv('TCHi.csv',header=True)
#TCHe.to_csv('TCHe.csv',header=True)
#TCHWSR.to_csv('TCHWSR.csv',header=True)
#mCH_tot.to_csv('mCH_tot.csv',header=True)
#mCH_totON.to_csv('mCH_totON.csv',header=True)
#
#Qhat.to_csv('Qhat.csv',header=True)
#QBL.to_csv('QBL.csv',header=True)
#mr.to_csv('mr.csv',header=True)
#ms_charge_hat.to_csv('ms_charge_hat.csv',header=True)
#z.to_csv('z.csv',header=True)
#Ts.to_csv('Ts.csv',header=True)