import os
from pandas import *
import datetime
from H_utility import *

def naming(filename):
    if 'Central Plant_' in filename:
        name='ST' # stroage temperature
    elif 'Chiller - Condensor Water Flow Rate' in filename:
        name='mCW'
    elif 'Chiller - Condensor Water Return Temp' in filename:
        name='TCWR'
    elif 'Chiller - Condensor Water Supply Temp' in filename:
        name='TCWS'
    elif 'Chiller Plant Performance - 3 Weidt' in filename:
        name='PCT'
    elif 'Chiller Plant Performance - Chiller_kWCSV' in filename:
        name='PCH_kW'
    elif 'Chiller Plant Performance - Chilling' in filename:
        name='QCH_ton'
    elif 'Chiller Plant Performance - Secondary Dist Pump' in filename:
        name='PP2'
    elif 'Cooling Plant - 1 Weidt Cooling' in filename:
        name='TCHS_n_TCHR'
    elif 'Cooling Plant - Chilled Water Return Flow' in filename:
        name='mr'
    elif 'Cooling Plant - Primary flow vs CHWRTCSV' in filename:
        name='mCH_n_mr'
    elif 'TES Tank - Percent CapacityCSV' in filename:
        name='z'
    elif 'UC Merced - Chiller - CoolingLoad' in filename:
        name='QCHL'
    elif 'UC Merced - Chiller Inlet Water Temp' in filename:
        name='TCHi'
    elif 'UC Merced - Chiller Outlet Water Temp' in  filename:
        name='TCHe'
    elif 'UC Merced - Chiller - Power' in filename:
        name='PCH'
    elif 'UC Merced - Weather - AirTemp' in filename:
        name='Toa'
    elif 'UC Merced - Weather - RH' in filename:
        name='RH'
    else:
        error()
    return name
    
    
def enum(quantity, iCH):
    if 'TCWS' in quantity:
        if iCH<=3:
            name='CH-'+ str(iCH)+' CWS Temp' 
        else:
            name='CH-'+ str(iCH)+' CWL Temp' # file name is wrong! for 123 condensor water supply but for 4,5 they are CWL i.e. CWR! 
    elif 'TCWR' in quantity:
        if iCH<=3:
            name='CH-'+ str(iCH)+' CWR Temp' 
        else:
            name='CH-'+ str(iCH)+' CWE Temp' # file name is wrong! for 123 condensor water supply but for 4,5 they are CWL i.e. CWR! 
    elif 'Q' in quantity:
        if iCH==1:
            name='Load'
        else:
            name='Load (' + str(iCH)+')'
    elif 'P' in quantity:
        if iCH==1:
            name='MOTOR KW'
        else:
            name='MOTOR KW (' + str(iCH)+')'
    elif 'TCHi' in quantity:
        if iCH<=3:
            name='ch-'+str(iCH)+' chwr' # return
        else:
            name='ch-'+str(iCH)+' chwe' # entering
    
    elif 'TCHe' in quantity:
        if iCH<=3:
            name='ch-'+str(iCH)+' chws' # supply
        else:
            name='ch-'+str(iCH)+' chwl' # leaving
    
        
    return name

#    
def xldate_to_datetime(excel_time):
    number_of_days_from_19000101=excel_time
    temp = datetime.datetime(1899, 12, 30)
    return temp+datetime.timedelta(number_of_days_from_19000101)# timedelta: number of days in R --> datetime obj

  
#% wanna  unzip?
currentfolder='/home/adun6414/Work/CERC_UCM'
os.chdir(currentfolder)


#% read 2018, 2019 data

#dateparse = lambda dates: [datetime.strptime(d, '%m/%d/%Y %H:%M:%S %I') for d in dates]

for yr in [2018,2019]:
    if yr==2018:    
        os.chdir('/home/adun6414/Work/CERC_UCM/RawData/H_extracted/d2018/combined')
        d2018=dict()
    elif yr==2019:
        os.chdir('/home/adun6414/Work/CERC_UCM/RawData/H_extracted/d2019/combined')
        d2019=dict()

    filenames=os.listdir(os.getcwd()) # unzipped cvs
        

    for i in range(len(filenames)):   
        if ('Toa' in filenames[i]) or ('RH'  in filenames[i]) or ('z'  in filenames[i]):
            d=read_csv(filenames[i],header=1,usecols=[0,1,2])
            # or sckiprows=1 rather than header=1
        else:
            d=read_csv(filenames[i])#,parse_dates=['Date'])#read_csv(filenames[i], parse_dates=['Date'], date_parser=dateparse)#read_csv(filenames[i],parse_dates=['Date'])
        #d=d.set_index('Date')
        #d=d.drop('Excel Time',axis='columns')
        
        if yr==2018:
            d2018[filenames[i].split('.')[0]]=d
        elif yr==2019:
            d2019[filenames[i].split('.')[0]]=d
    
#% merge 2018, 2019 data
data=dict()
for i in range(len(filenames)):
    name=filenames[i].split('.')[0]
    data[name]=merge(d2018[name],d2019[name],how='outer') # outer =union

#% EXCEL TIME TO DATETIME OBJ, drop excel time, set index as date and sort by date

for i in range(len(filenames)):
    name=filenames[i].split('.')[0]
    data[name]['Date']=data[name]['Excel Time'].apply(xldate_to_datetime)
    data[name]=data[name].drop('Excel Time',axis='columns')
    data[name]=data[name].set_index('Date')
    data[name]=data[name].sort_values(by='Date',ascending=True)
    
#%% analysis
os.chdir(currentfolder)
from numpy import *
from H_utility import *
close('all')
#%% condensor water flow rate is constantly controlled.
startdate='2018-08-01'#'2019-08-01'
enddate='2018-09-30'#'2019-08-3' 
# close('all')

mCW=data['mCW'][startdate:enddate].resample('15T').mean() # gpm???
mCW.columns=['1','2','3','4','5']
mCW[mCW>300].hist(bins=100,alpha=0.5)
title('CW [gpm?]')
savefig('mCWpgm.png')
mCWscale=mCW/mCW.dropna().max()
mCWtot=mCW.sum(axis=1)
#%% m cooling tower
mCTtot=mCW.sum(axis=1)
figure()
mCTtot.plot()
title('mCT total [gpm?]')
savefig('mCT_tot_gpm.png')

#%% weather data
Toa=data['Toa'][startdate:enddate].resample('15T').mean()
RH=data['RH'][startdate:enddate].resample('15T').mean()
Weather=Toa.merge(RH,on='Date',how='inner')
Weather.columns=['Toa','RH']
Weather=Weather.dropna()
from CoolProp.HumidAirProp import HAPropsSI
Twb = HAPropsSI('B','T',Weather.iloc[:,0].to_numpy()+273.15,'R',Weather.iloc[:,1].to_numpy()*1./100,'P',101325) #HumRat(AirH2O,T=T_a_in , P=p_atm,B=T_wb_in ) "lbm/lbm"                "Humidity ratio"
Weather['Twb']=k2c(Twb)

#%% Cooling Tower Power << sequencing. 
PCT=data['PCT'][startdate:enddate].resample('15T').mean()
PCT[[k for k in PCT.columns.to_list() if 'Power' in k]].plot()
PCTtot=PCT[[k for k in PCT.columns.to_list() if 'Power' in k]].sum(axis=1)

PCT.plot()
title('PCT')

figure()
PCTtot.plot()
title('PCT')
savefig('PCT_total_kW.png')

#%% check it is exactly correlated with chiller operation

PCH=data['PCH_kW'][startdate:enddate].resample('15T').mean()
PCH['sum']=PCH.sum(axis=1)
#PCH[PCH>0].iloc[:,0:5].plot.hist(bins=30,alpha=0.5)
# 1. whenever 4 is activated, 5 is activated and none of 1,2,3 are activated.
ON=DataFrame()
ONPLOT=DataFrame()
mCWPLOT=DataFrame()
for i in range(1,6):
    ON[str(i)]=1*(PCH[enum('P',i)]>10)
    ONPLOT[str(i)]=1*(PCH[enum('P',i)]>10)+i-1
    mCWPLOT[str(i)]=mCWscale[str(i)]+i-1
    
fig,ax=subplots(1,1)
ONPLOT.plot(ax=ax)
mCWPLOT.plot(ax=ax)
savefig('data_mCW_PCHON.png')

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

#%% 
dum=DataFrame()
dum['TCWS']=TCWS.mean(axis=1).apply(f2c)
dum['TCWR']=TCWR.mean(axis=1).apply(f2c)
dum['mCW']=mCWtot.apply(gpm2kgs)
QCT_tot=dum['mCW']*4.2*(dum['TCWR']-dum['TCWS'])
figure()
QCT_tot.apply(kW2ton).plot()
title('QCT_tot_ton')

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
mflow[mflow['Primary CHWS Flow'] >5000]=0.5*mflow[mflow['Primary CHWS Flow'] >5000]   
mCHT=mflow['Primary CHWS Flow'].apply(gpm2kgs).to_frame()
mCHTON=mCHT.merge(ON,on='Date')


figure()
mflow['Primary CHWS Flow'].plot(style='.-');grid(True);ylabel('gpm')

savefig('data_mgpm.png') 
#check flow is consistent with power on off
figure()
ONPLOT.plot()
#(mCHT/max(mCHT.dropna())*6).plot()

#%% split mCHtotal to each mCH

for i in range(1,6):
    mCHTON[str(i)]=multiply(mCHTON[str(i)],mCHTON['Primary CHWS Flow'])    

Qhat=DataFrame()
for i in range(1,6):
    Qhat[str(i)]=multiply(4.2*mCHTON[str(i)], TCHi[str(i)].apply(f2c)-TCHe[str(i)].apply(f2c))
#%%
figure()
for i in range(1,6):
    ax=subplot(5,1,i)
    Qhat[str(i)].plot(ax=ax)
    #QCHLkW[enum('Q',i)].plot(ax=ax,style='r')

savefig('data_QkW.png') 
#Qhat=mCH*4.2*(TCHi-TCHe)
Rawdata_CH={'index':mCHTON.index,'mCHTON':mCHTON.to_numpy(), 'Qhat':Qhat.to_numpy(), 'PkWiCH':PkWiCH.to_numpy(),'TCHe':TCHe.to_numpy(),'TCHi':TCHi.to_numpy(),'TCWS':TCWS.to_numpy(),'TCWR':TCWR.to_numpy()}
sp.io.savemat('Rawdata_CH',Rawdata_CH)
