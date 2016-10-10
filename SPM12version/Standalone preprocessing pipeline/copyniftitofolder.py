# -*- coding: utf-8 -*-
""" 

Moves preprocessed files to another directory as specified in src, dst

"""

import shutil
import os
import fnmatch

src = "./" # input
dst = "smoothedniftis/" # desired     location
#    
#src = "test1/" # input
#dst = "test2/" # desired     location


def copyniftitofolder():
    for (dirpath, dirs, filelist) in os.walk(src):
        for files in filelist:
            if files.startswith('sm_condition') and dirpath.find('EEGwpfmcfbMdeM')!=-1:
                if dirpath.find('_vc')==-1:
                    dirend = ('EEG/'+files.split('_')[-1].split('.')[0]+'/patients')
                    participantid = dirpath[dirpath.find('_vp')+1:dirpath.find('_vp')+5]
                    if participantid.endswith('/'):
                        participantid = participantid[:-1]                        
                elif dirpath.find('_vp')==-1:
                    dirend = ('EEG/'+files.split('_')[-1].split('.')[0]+'/controls')
                    participantid = dirpath[dirpath.find('_vc')+1:dirpath.find('_vc')+5]
                    if participantid.endswith('/'):
                        participantid = participantid[:-1] 
                if not os.path.isdir(dst+dirend):
                    os.makedirs(dst+dirend)
                shutil.copy(os.path.join(dirpath,files),os.path.join(dst,dirend,participantid+'_'+files))
                print ('Copied ' + os.path.join(dirpath,files) + ' to ' + os.path.join(dst,dirend,participantid+'_'+files))
            elif files.startswith('sm_condition') and dirpath.find('MEGPLANARwpfmcfbMdeM')!=-1:
                if dirpath.find('_vc')==-1:
                    dirend = ('MEGPLANAR/'+files.split('_')[-1].split('.')[0]+'/patients')
                    participantid = dirpath[dirpath.find('_vp')+1:dirpath.find('_vp')+5]
                    if participantid.endswith('/'):
                        participantid = participantid[:-1]                        
                elif dirpath.find('_vp')==-1:
                    dirend = ('MEGPLANAR/'+files.split('_')[-1].split('.')[0]+'/controls')
                    participantid = dirpath[dirpath.find('_vc')+1:dirpath.find('_vc')+5]
                    if participantid.endswith('/'):
                        participantid = participantid[:-1] 
                if not os.path.isdir(dst+dirend):
                    os.makedirs(dst+dirend)
                shutil.copy(os.path.join(dirpath,files),os.path.join(dst,dirend,participantid+'_'+files))
                print ('Copied ' + os.path.join(dirpath,files) + ' to ' + os.path.join(dst,dirend,participantid+'_'+files))
            elif files.startswith('sm_condition') and dirpath.find('MEGwpfmcfbMdeM')!=-1:
                if dirpath.find('_vc')==-1:
                    dirend = ('MEG/'+files.split('_')[-1].split('.')[0]+'/patients')
                    participantid = dirpath[dirpath.find('_vp')+1:dirpath.find('_vp')+5]
                    if participantid.endswith('/'):
                        participantid = participantid[:-1]                        
                elif dirpath.find('_vp')==-1:
                    dirend = ('MEG/'+files.split('_')[-1].split('.')[0]+'/controls')
                    participantid = dirpath[dirpath.find('_vc')+1:dirpath.find('_vc')+5]
                    if participantid.endswith('/'):
                        participantid = participantid[:-1] 
                if not os.path.isdir(dst+dirend):
                    os.makedirs(dst+dirend)
                shutil.copy(os.path.join(dirpath,files),os.path.join(dst,dirend,participantid+'_'+files))
                print ('Copied ' + os.path.join(dirpath,files) + ' to ' + os.path.join(dst,dirend,participantid+'_'+files))
                
            else:
                print ('Did not copy ' + os.path.join(dirpath,files))
                
