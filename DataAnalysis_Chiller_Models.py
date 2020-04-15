import os
from pandas import *
import scipy as sp

currentfolder='/home/adun6414/Work/CERC_UCM'
os.chdir(currentfolder)
filenames=os.listdir(os.getcwd())
matfiles=[k for k in filenames if '.mat' in k]
Chiller_model_file=[k for k in matfiles if 'ChillerM' in k]
Rawdata_file=[k for k in matfiles if 'Rawdata' in k]

M0=sp.io.loadmat(Chiller_model_file[0])
