#!/usr/bin/env python
# LIBPATH.py V2
import os
class libpath:
    def __init__(self,inpath:str):
        mypaths=os.environ[inpath].split(':')
        self.valid_path=[]
        self.invalid_path=[]
        self.duplicated_path=[]
        for dir in mypaths:
            full_dir = os.path.abspath(dir)
            if not os.path.isdir(dir):
                self.invalid_path.append(dir)
            elif full_dir in self.valid_path:
                self.duplicated_path.append(full_dir)
            else:
                self.valid_path.append(full_dir)
