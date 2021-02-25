# LIBSTR.py v1
'''
Python version of lib/libstr, includes common string-output utilities.
See 'yldoc libstr' for more details.
'''
import sys


def eprint(*args, **kwargs):
	'''
	Enhanced print to standard error.
	:param args: What needed to be print.
	:param kwargs: Other arguments supplied to function 'print'.
	'''
	print(*args, file=sys.stderr, **kwargs)


def infoh(instr: str):
	eprint("\033[33m", instr, "\033[0m")


def warnh(instr: str):
	eprint("\033[31mWARNING:", instr, "\033[0m")


def errh(instr: str):
	eprint("\033[31mERROR:", instr, "\033[0m")
	sys.exit(1)
