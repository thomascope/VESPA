# -*- coding: utf-8 -*-
""" 

Moves preprocessed files to another directory as specified in src, dst

"""

import shutil
import os
import fnmatch

src = "preprocess/" # input
dst = "preprocess/SPM12/" # desired     location
#    
#src = "test1/" # input
#dst = "test2/" # desired     location


def copytrialdefinitions():
    for (dirpath, dirs, filelist) in os.walk(src):
        for files in filelist:
            if files.startswith('trlDef') and files.endswith('mat') and dirpath.find('SPM12')==-1:
                dirend = dirpath[len(src):]
                if not os.path.isdir(dst+dirend):
                    os.makedirs(dst+dirend)
                shutil.copy(os.path.join(dirpath,files),os.path.join(dst,dirend,files))
                print ('Copied ' + os.path.join(dirpath,files) + ' to ' + os.path.join(dst,dirend,files))
            else:
                print ('Did not copy ' + os.path.join(dirpath,files))
