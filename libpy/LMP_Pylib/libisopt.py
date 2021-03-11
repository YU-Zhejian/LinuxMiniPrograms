#!/usr/bin/env python
# LIBISOPT.py V3
"""
Python version of lib/libisopt, includes utilities to judge whether an argument is an option.
See 'yldoc libisopt' for more details.
"""
import re

my_opt = re.compile(r'-[^-\s]|--\S+|-[^-\s]\:\S+|--\S+:\S+')


def isopt(S: str) -> bool:
	"""
	Is it an option?
	:param S: What needed to be judged.
	:return: Whether it is an option.
	"""
	if my_opt.match(S):
		return True
	else:
		return False
