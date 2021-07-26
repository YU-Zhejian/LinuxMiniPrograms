#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
The installation script
'''
from setuptools import setup

VERSION = 1.1

setup(name='linuxminipy',
      version=VERSION,
      description='Python libraries for LinuxMiniPrograms',
      author='YuZJ',
      author_email='theafamily@126.com',
      maintainer='YuZJ',
      maintainer_email='anandology@gmail.com',
      url='https://github.com/YuZJLab/LinuxMiniPrograms',
      packages=['linuxminipy'],
      long_description='Python libraries for LinuxMiniPrograms',
      license='GPL v3',
      platforms=['any'],
      )
