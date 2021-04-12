#!/usr/bin/env python
# VERSION=2.3
'''
Python version of lib/libpath, includes common utilities to manipulate
environment variables separated by ':'.
See 'yldoc libpath' for more details.
'''
import os


class LibPath:
	'''
	The results extracted will be placed inside this class.
	'''
	def __init__(self, inpath: str, sep: str = ':'):
		'''
		:param inpath: The environment variable name
		'''
		mypaths = os.environ[inpath].split(sep)
		self.valid_path = []
		self.invalid_path = []
		self.duplicated_path = []
		for dirs in mypaths:
			full_dir = os.path.abspath(dirs)
			if not os.path.isdir(dirs):
				self.invalid_path.append(dirs)
			elif full_dir in self.valid_path:
				self.duplicated_path.append(full_dir)
			else:
				self.valid_path.append(full_dir)
		self.invalid_path=list(set(self.invalid_path))
		self.invalid_path=list(set(self.invalid_path))
		self.valid_path=list(set(self.valid_path))
		self.duplicated_path=list(set(self.duplicated_path))
		self.invalid_path.sort()
		self.valid_path.sort()
		self.duplicated_path.sort()
