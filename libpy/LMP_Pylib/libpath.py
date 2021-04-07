#!/usr/bin/env python
# VERSION=2
'''
Python version of lib/libpath, includes common utilities to manipulate environment variables separated by ':'.
See 'yldoc libpath' for more details.
'''
import os


class libpath:
	def __init__(self, inpath: str):
		'''
		:param inpath: The environment variable name
		'''
		mypaths = os.environ[inpath].split(':')
		self.valid_path = []
		self.invalid_path = []
		self.duplicated_path = []
		for dir in mypaths:
			path_hand = os.popen('readlink -f \"' + dir + '"')
			full_dir = path_hand.read().strip()
			path_hand.close()
			if not os.path.isdir(dir):
				self.invalid_path.append(dir)
			elif full_dir in self.valid_path:
				self.duplicated_path.append(full_dir)
			else:
				self.valid_path.append(full_dir)
