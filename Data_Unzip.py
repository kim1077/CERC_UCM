import os
from pandas import *
import datetime

def xldate_to_datetime(excel_time):
    number_of_days_from_19000101=excel_time
    temp = datetime.datetime(1899, 12, 30)
    return temp+datetime.timedelta(number_of_days_from_19000101)# timedelta: number of days in R --> datetime obj


def naming(filename):
    if 'Chiller - Condensor Water Flow Rate' in filename:
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
        name='QCHL' ## This is crap or something else!
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
    elif 'Central Plant_ 0208 - TT-13_to_TT-28CSV' in filename:
        name='Ts1328'
    elif 'Central Plant_ 0208 - TT-29_to_TT-44CSV' in filename:
        name='Ts2944'
    elif 'Central Plant_ 0208 - TT-45_to_TT-56CSV' in filename:
        name='Ts4556'    
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
#%%
def Unzip_all(New_data):
    #%% wanna  unzip?
    
    currentfolder='/home/adun6414/Work/CERC_UCM'
    
    
    
    #%% unziping
    
    os.chdir('/home/adun6414/Work/CERC_UCM/RawData')
    if New_data==1:
        
        # deleting all previously extracted files
        try:
            import shutil
            shutil.rmtree(os.path.join('/home/adun6414/Work/CERC_UCM/RawData','H_extracted'))
        except:
            print('nothing to remove')
        
        
        zippedfilename=os.listdir(os.getcwd())     
        from zipfile import ZipFile
        k=0
        j=0
        for izipfile in zippedfilename:
            if '.zip' in izipfile: # pick only zipfile
                print izipfile
                k=k+1
                #Create a zipfile object for the ith zip file
                with ZipFile(izipfile) as obj:
                   # Get a list of all archived file names in a zip file
                   filesinzip = obj.namelist()
                   # Iterate over the file names
                   for jfileinzip in filesinzip:
                       # Check filename startswith combined
                       if jfileinzip.startswith('combined'):
                           if izipfile.endswith('(1).zip'):
                               obj.extract(jfileinzip, 'H_extracted/d2019')
                               # renaming
                               os.rename('H_extracted/d2019/'+jfileinzip,'H_extracted/d2019/combined/'+naming(obj.filename)+'.csv')
                               
                           else:
                               obj.extract(jfileinzip, 'H_extracted/d2018')
                               # renaming
                               os.rename('H_extracted/d2018/'+jfileinzip,'H_extracted/d2018/combined/'+naming(obj.filename)+'.csv')
                               
                           print '==========extracted =====================\n'
                           j=j+1 
        print 'total zipfile', k
        print 'total extractted zipfile', j
    
        # treatment files which do not have 'combined' cvs file
        for izipfile in zippedfilename:
            if any(['UC Merced - Weather - AirTemp' in izipfile, 
                    'UC Merced - Weather - RH' in izipfile,
                    'TES Tank - Percent Capacity' in izipfile]):
                        
                with ZipFile(izipfile) as obj:
                    filesinzip = obj.namelist()
                    if len(filesinzip)!=1: # I expect only one file in a zipfile
                        error()
                    else:
                        jfileinzip=filesinzip[0]
                        
                    if izipfile.endswith('(1).zip'):
                        obj.extract(jfileinzip, 'H_extracted/d2019')
                        # renaming
                        os.rename('H_extracted/d2019/'+jfileinzip,'H_extracted/d2019/combined/'+naming(obj.filename)+'.csv')                           
                    else:
                       obj.extract(jfileinzip, 'H_extracted/d2018')
                       # renaming
                       os.rename('H_extracted/d2018/'+jfileinzip,'H_extracted/d2018/combined/'+naming(obj.filename)+'.csv')
                          
    
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
        
        
        # df=df.merge(d,how='inner') # intersection
        
     #   print i, filenames[i], df.size
        # on : label or list,     Column or index level names to join on. These must be found in both
        # DataFrames. If `on` is None and not merging on indexes then this defaults
        # to the intersection of the columns in both DataFrames.
    #df.sort_values(by='Date',ascending=True) # time increasing
    
    #%% EXCEL TIME TO DATETIME OBJ, drop excel time, set index as date and sort by date
    
    for i in range(len(filenames)):
        name=filenames[i].split('.')[0]
        data[name]['Date']=data[name]['Excel Time'].apply(xldate_to_datetime)
        data[name]=data[name].drop('Excel Time',axis='columns')
        data[name]=data[name].set_index('Date')
        data[name]=data[name].sort_values(by='Date',ascending=True)
    
    
    return data
    
if __name__=='__main__':
    wanna_re_unzip=1
    data=Unzip_all(wanna_re_unzip)