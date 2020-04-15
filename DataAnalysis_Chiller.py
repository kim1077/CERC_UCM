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

# 

def f_QflkW(T_degC,iCH=1,Q0kW=4.2e3,thetaQfl=mat([0.70790824,-0.002006568,-0.00259605,0.030058776,-0.0010564344,0.002045703]).T):
    Tchws=mat(T_degC[:,0])
    Tcws=mat(T_degC[:,1])    
    if iCH is not 1:
        error()
    else:
        PHI=zeros((Tchws.size,6))
        for i in range(Tchws.size):
            PHI[i,:]=mat([1,Tchws[i],Tchws[i]**2,Tcws[i],Tcws[i]**2,Tcws[i]*Tchws[i]])
        Qfl=Q0kW*PHI*thetaQfl
    return Qfl


def f_PflkW(T_degC,iCH=1,P0=4.2e3/7,Q0=4.2e3,thetaQfl=mat([0.70790824,-0.002006568,-0.00259605,0.030058776,-0.0010564344,0.002045703]).T, thetaEIRfl=mat([0.5605438,-0.01377927,6.57072e-005,0.013219362,0.000268596,-0.0005011308]).T):
    # Pfl(Temps):=1/COPfullcompressor(Temps)*Qfl(Temp)        
    Tchws=mat(T_degC[:,0])
    
    Tcws=mat(T_degC[:,1])    
    if iCH is not 1:
        error()
    else:
        PHI=zeros((Tchws.size,6))
        for i in range(Tchws.size):
            PHI[i,:]=mat([1,Tchws[i],Tchws[i]**2,Tcws[i],Tcws[i]**2,Tcws[i]*Tchws[i]])
        EIRfl=PHI*thetaEIRfl
        
        
        Qfl=f_QflkW(T_degC,1,Q0,thetaQfl)
        Pfl=P0*multiply(EIRfl,Qfl)/Q0
        
    return Pfl

def Pmap(TQ,P0=4.2e3/7,Q0=4.2e3,thetaQfl=mat([0.70790824,-0.002006568,-0.00259605,0.030058776,-0.0010564344,0.002045703]).T, thetaEIRfl=mat([0.5605438,-0.01377927,6.57072e-005,0.013219362,0.000268596,-0.0005011308]).T, thetaPPLR=mat([0.17149273,0.58820208,0.23737257]).T):
    T_degC=mat(TQ[:,0:2])    
    QkW=H_iscolumn(mat(TQ[:,2]))
    # maximum cap cal
    Qfl=f_QflkW(T_degC,1,Q0,thetaQfl)
    # maximum power cal    
    Pfl=f_PflkW(T_degC,1,P0,Q0,thetaQfl,thetaEIRfl)
    #calculate PLR and influence of PLR on Power    
    PLR=np.divide(QkW,Qfl)
    PHI=zeros((QkW.size,thetaPPLR.size))
    
    for i in range(PLR.size):
        PHI[i,:]=mat([1,PLR[i],PLR[i]**2])
    factor_PLR=PHI*thetaPPLR
    Pow=np.multiply(Pfl,factor_PLR)

    #figure(202)
    #plot(PLR,factor_PLR,'o')
    
    return Pow
        
def yprediction(x0,y):
    
    P0=4.2e3/7*x0[0]
    Q0=4.2e3*x0[1]
    thetaQfl=mat([0.70790824,-0.002006568,-0.00259605,0.030058776,-0.0010564344,0.002045703]).T
    thetaEIRfl=mat([0.5605438,-0.01377927,6.57072e-005,0.013219362,0.000268596,-0.0005011308]).T
    thetaPPLR=mat([0.17149273,0.58820208,0.23737257]).T
    Phat=Pmap(dataiCH.iloc[:,1:].values,P0,Q0,thetaQfl,thetaEIRfl,thetaPPLR)    
    return Phat

def yprediction_err(x0,y):
    Phat=yprediction(x0,y)
    Pmea=y        
    err=Phat-Pmea
    err=err[~isnan(err)]
    return np.squeeze(np.asarray(err.T))#np.squeeze(np.asarray(np.reshape(err,(1,-1))))    
##%%
#H_fitlab2(np.array([0,8]),np.array([10,30]),f_QflkW)
#
##%%
#H_fitlab2(np.array([0,8]),np.array([10,30]),f_PflkW)
##%%
#H_fitlab2(np.array([0,8,4.2e3*0.3]),np.array([10,30,4.2e3*1]),Pmap)  
    
#%% wanna  unzip?
currentfolder='/home/adun6414/Work/CERC_UCM'
os.chdir(currentfolder)


#%% read 2018, 2019 data

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
    
#%% merge 2018, 2019 data
data=dict()
for i in range(len(filenames)):
    name=filenames[i].split('.')[0]
    data[name]=merge(d2018[name],d2019[name],how='outer') # outer =union

#%% EXCEL TIME TO DATETIME OBJ, drop excel time, set index as date and sort by date

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
#%% chiller load load plot
startdate='2018-08-01'#'2019-08-01'
enddate='2018-09-30'#'2019-08-3' 
# close('all')

QCHLkW=data['QCHL'][startdate:enddate].resample('15T').mean()
QCHLton=QCHLkW.apply(kW2ton)


PCH=data['PCH_kW'][startdate:enddate].resample('15T').mean()
PCH['sum']=PCH.sum(axis=1)
#PCH[PCH>0].iloc[:,0:5].plot.hist(bins=30,alpha=0.5)
# 1. whenever 4 is activated, 5 is activated and none of 1,2,3 are activated.
ON=DataFrame()
ONPLOT=DataFrame()
for i in range(1,6):
    ON[str(i)]=1*(PCH[enum('P',i)]>10)
    ONPLOT[str(i)]=1*(PCH[enum('P',i)]>10)+i
figure()
ONPLOT.plot()
savefig('data_chiller_stage.png')

#%% 1,2,3 are named correctly but 4,5 are opposite
TCWS=data['TCWS'][startdate:enddate].resample('15T').mean()
TCWR=data['TCWR'][startdate:enddate].resample('15T').mean()
figure()
for i in range(1,6):
    ax=subplot(5,1,i)
    TCWS[enum('TCWS',i)].plot(ax=ax,style='.-')
    TCWR[enum('TCWR',i)].plot(ax=ax,style='.-')
    legend(['TCWS','TCWR'])
    grid(True)

#%% rename data
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

savefig('data_TCW.png')      
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
#%% rename data
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

savefig('data_TCHW.png') 
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
    QCHLkW[enum('Q',i)].plot(ax=ax,style='r')

savefig('data_QkW.png') 
#Qhat=mCH*4.2*(TCHi-TCHe)

#%% Chiller modeling ==================================================================
import scipy as sp

close('all')
QF=np.array([1.5,1.3,1.3,1.2,1.2])
for iCH in arange(1,6):
    PkWiCH=PCH[enum('P',iCH)].to_frame()
    TCHeiCH=TCHe[str(iCH)].apply(f2c)
    TCWSiCH=TCWR[str(iCH)].apply(f2c) # note TCWR and TCWS are switched!!
    QCHLiCH=Qhat[str(iCH)]
    dataiCH=PkWiCH.merge(TCHeiCH,on='Date')
    dataiCH=dataiCH.merge(TCWSiCH,on='Date')
    dataiCH=dataiCH.merge(QCHLiCH,on='Date')
    dataiCH.columns=['P','TCHe','TCWS','QL']
    dataiCH=dataiCH[(dataiCH['P']>10) & (dataiCH['QL']>10)]
    #dataiCH=dataiCH[(dataiCH[enum('P',iCH)]>10) & (dataiCH[enum('Q',iCH)]>10) & (dataiCH[enum('TCHe',iCH)]>3)]   
    
    #dataiCH=dataiCH[(dataiCH[enum('P',iCH)]>10) & (dataiCH[enum('Q',iCH)]>dataiCH[enum('P',iCH)]) ]
    dataviCH=dataiCH.dropna().values
    
    
    plotting.scatter_matrix(dataiCH)
    title(str(iCH))
    savefig('ChillerM'+str(iCH)+'_scatter.png')
    
    dataiCH.plot(style='o-')
    savefig('ChillerM'+str(iCH)+'_datatime.png')
    
    Y=mat(dataviCH[:,0]).T
    PHI=mat(hstack((ones((Y.size,1)),dataviCH[:,1:])))
    theta=linalg.pinv(PHI.T*PHI)*PHI.T*Y
    hatY=Y.copy()
    
    for k in range(len(Y)):
        hatY[k]=PHI[k,:]*theta
    figure()
    H_plotc(Y,hatY)
    xlabel('measured P[kW]')
    ylabel('predicted P[kW]')
    title('chiller'+str(iCH))
    savefig('ChillerM'+str(iCH)+'_HLS_compare.png')
    
    
    #%
    P0=4.2e3/7
    Q0=4.2e3*QF[iCH-1]
    Pmea=dataiCH.iloc[:,0].values
    Phat=Pmap(dataiCH.iloc[:,1:].values,P0,Q0)
    figure()
    H_plotc(mat(H_iscolumn(Pmea)),Phat)
    xlabel('measured P[kW]')
    ylabel('predicted P[kW]')
    title('chiller'+str(iCH))
    savefig('ChillerM'+str(iCH)+'_DOE2_compare.png')
    
    
    figure()
    Pcomp=DataFrame(np.vstack((Pmea,Phat.T)).T,columns=['Pmea','Phat'],index=dataiCH.index)
    Pcomp.plot()    
    savefig('ChillerM'+str(iCH)+'_DOE2_time.png')
    
    ChillerM={'data':dataiCH.to_numpy(),'index':dataiCH.index,'theta':theta,'Q0':Q0}
    sp.io.savemat('ChillerM'+str(iCH),ChillerM)
    
Rawdata_CH={'index':mCHTON.index,'mCHTON':mCHTON.to_numpy(), 'Qhat':Qhat.to_numpy(), 'PkWiCH':PkWiCH.to_numpy(),'TCHe':TCHe.to_numpy(),'TCHi':TCHi.to_numpy(),'TCWS':TCWS.to_numpy(),'TCWR':TCWR.to_numpy()}
sp.io.savemat('Rawdata_CH',Rawdata_CH)