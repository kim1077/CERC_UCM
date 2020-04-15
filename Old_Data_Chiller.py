import os
from pandas import *
import datetime
from H_utility import *

def enum(quantity, iCH):
    if 'TCWS' in quantity:
        if iCH<=3:
            name='CH-'+ str(iCH)+' CWS Temp' 
        else:
            name='CH-'+ str(iCH)+' CWL Temp' 
    elif 'TCWR' in quantity:
        if iCH<=3:
            name='CH-'+ str(iCH)+' CWR Temp' #<< name convention is opposite
        else:
            name='CH-'+ str(iCH)+' CWE Temp' 
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

#%%    
def xldate_to_datetime(excel_time):
    number_of_days_from_19000101=excel_time
    temp = datetime.datetime(1899, 12, 30)
    return temp+datetime.timedelta(number_of_days_from_19000101)# timedelta: number of days in R --> datetime obj

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
from numpy import *
from H_utility import *

#%% chiller load load plot
startdate='2018-01-01'#'2019-08-01'
enddate='2019-12-31'#'2019-08-3' 
close('all')

QCHLkW=data['QCHL'][startdate:enddate]
QCHLton=QCHLkW.apply(kW2ton)


PCH=data['PCH_kW'][startdate:enddate]
PCH['sum']=PCH.sum(axis=1)
#PCH[PCH>0].iloc[:,0:5].plot.hist(bins=30,alpha=0.5)

#%% it was NOT that crazily missing. plot with 'o'
TCWS=data['TCWS'][startdate:enddate]
TCWR=data['TCWR'][startdate:enddate]
TCWS.plot()
grid(True)
ylabel('TCWS')

#%% the best guess is mean TCWS, TCWR
TCWSm=data['TCWS'][startdate:enddate].iloc[:,3:5].mean(axis=1,skipna=True,numeric_only=True).to_frame()
TCWRm=data['TCWR'][startdate:enddate].iloc[:,3:5].mean(axis=1,skipna=True,numeric_only=True).to_frame()
figure(1)
TCWSm.plot()
TCWRm.plot()
grid(True)
legend(['TCWS','TCWR']) ##<<< switched????


#%% TCHWS & R 
TCHi=data['TCHi'][startdate:enddate]
TCHe=data['TCHe'][startdate:enddate]
figure(2)
TCHi.plot()
TCHe.plot()
grid(True)
legend(['TCHi','TCHe'])

#%% Chiller data
#PCH[kW]=(TCHe[^oC],TCWS[^oC],QCH[kW])
close('all')
for iCH in arange(3,4):
    PkWiCH=PCH[enum('P',iCH)].to_frame()
    TCHeiCH=TCHe[enum('TCHe',iCH)].apply(f2c)
    TCWSiCH=TCWR[enum('TCWR',iCH)].apply(f2c) # note TCWR and TCWS are switched!!
    QCHLiCH=QCHLkW[enum('Q',iCH)]
    dataiCH=PkWiCH.merge(TCHeiCH,on='Date')
    dataiCH=dataiCH.merge(TCWSiCH,on='Date')
    dataiCH=dataiCH.merge(QCHLiCH,on='Date')
    dataiCH=dataiCH[(dataiCH[enum('P',iCH)]>10) & (dataiCH[enum('Q',iCH)]>10) ]
    #dataiCH=dataiCH[(dataiCH[enum('P',iCH)]>10) & (dataiCH[enum('Q',iCH)]>10) & (dataiCH[enum('TCHe',iCH)]>3)]   
    
    #dataiCH=dataiCH[(dataiCH[enum('P',iCH)]>10) & (dataiCH[enum('Q',iCH)]>dataiCH[enum('P',iCH)]) ]
    dataviCH=dataiCH.dropna().values

plotting.scatter_matrix(dataiCH)
title(str(iCH))
dataiCH.plot(style='o-')
Y=mat(dataviCH[:,0]).T
PHI=mat(hstack((ones((Y.size,1)),dataviCH[:,1:])))
theta=linalg.pinv(PHI.T*PHI)*PHI.T*Y
hatY=Y.copy()



for k in range(len(Y)):
    hatY[k]=PHI[k,:]*theta

H_plotc(Y,hatY)

#%% optimization
import scipy as sp


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
#%%
H_fitlab2(np.array([0,8]),np.array([10,30]),f_QflkW)

#%%
H_fitlab2(np.array([0,8]),np.array([10,30]),f_PflkW)
#%%
H_fitlab2(np.array([0,8,4.2e3*0.3]),np.array([10,30,4.2e3*1]),Pmap)  
#%%
Pmea=dataiCH.iloc[:,0].values
Phat=Pmap(dataiCH.iloc[:,1:].values)
H_plotc(mat(H_iscolumn(Pmea)),Phat)
title('Power [kW]')

#%% optimization due to degradation    
close('all')    
val=1e10
Niter=3
lb=np.array([0.9,0.99])
ub=np.array([1,1])
for iter in np.arange(1,Niter):
    THETA=np.zeros((Niter,2));
    start=np.random.uniform(lb,ub,2)
    
#        start=np.array([24.00,24.00,6.00,6.00,0.50,0.50,0.40,0.40,-1.00,-1.00,0.10,0.00,	0.00,0.00,0.00])
    x0=np.squeeze(np.asarray(start.T))
#        yHATT=yprediction(x0,u,y)
#        np.linalg.norm(yHATT-Y)
    #res=sp.optimize.least_squares(yprediction,x0,args=(mat(Pmea)),bounds=(np.squeeze(lb.T),np.squeeze(ub.T)),verbose=1);#,max_nfev=1000,ftol=1e-1)
            
    try:
        res=sp.optimize.least_squares(yprediction_err,x0,args=(mat(Pmea)),bounds=(np.squeeze(lb.T),np.squeeze(ub.T)),verbose=1,max_nfev=1000,ftol=1e-1)
        if res.cost<val:
            err=np.mat(yprediction_err(res.x,y)).T
            print('parameter has been updated ==============')
            print(np.std(err))
            print(res.optimality)
            print(res.x.T)
            print(iter)
            val=res.cost
            theta=res.x
        else:
           print('converged but not updated=================================')
    except:
        print('not converged=================================')
        
Phat=yprediction(theta,mat(H_iscolumn(Pmea)))        
H_plotc(mat(H_iscolumn(Pmea)),Phat)
title('Power [kW]')

