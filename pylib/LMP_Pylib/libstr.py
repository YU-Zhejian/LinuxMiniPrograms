import sys


def eprint(*args, **kwargs):
	print(*args, file=sys.stderr, **kwargs)


def infoh(instr: str):
	eprint("\033[33m", instr, "\033[0m")


def warnh(instr: str):
	eprint("\033[31mWARNING:", instr, "\033[0m")


def errh(instr: str):
	eprint("\033[31mERROR:", instr, "\033[0m")
	sys.exit(1)
