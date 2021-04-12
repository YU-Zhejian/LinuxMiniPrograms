#!/usr/bin/env python
'''
The installation script
'''
from setuptools import setup

VERSION=1.1
# TODO: Implement installation.

setup(name='LMP_Pylib',
	version=1,
	description='web.py: makes web apps',
	author='YuZJ',
	author_email='me@aaronsw.com',
	maintainer='YuZJ',
	maintainer_email='anandology@gmail.com',
	url='https://github.com/YuZJLab/LinuxMiniPrograms',
	packages=['LMP_Pylib'],
	long_description='Python libraries for LinuxMiniPrograms',
	license='GPL v3',
	platforms=['any'],
	)
