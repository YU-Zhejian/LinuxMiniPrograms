# LIBYLFILE.py V1
# TODO: docs
import os

from LMP_Pylib.libstr import *


def ylread(filename: str) -> str:
	'''
	Read a text and return its contents. Use '-' or '/dev/stdin' to read from standard input.
	:param filename: The path needed.
	:return: The contents inside a file.
	WARNING: This function is intended for SMALL files only.
	'''
	if filename=="-":
		filename="/dev/stdin"
	if filename!="/dev/stdin" and not os.path.isfile(filename):
		errh("File " + filename + " invalid")
	fh = open(filename)
	rets = fh.read().strip()
	fh.close()
	return rets


def ylreadline(filename: str):
	'''
	Split the result of ylread by new line characters.
	'''
	return ylread(filename).strip().split('\n')


def ylwrite(filename: str, contents: str):
	fh = open(filename, 'w')
	fh.write(contents)
	fh.close()


def yldo(cmd: str) -> str:
	ret_hand = os.popen(cmd)
	ret = ret_hand.read().strip()
	ret_hand.close()
	return ret


def mktemp(S: str) -> str:
	return yldo('mktemp -t ' + S)


def pywcl(filename: str) -> int:
	count = 0
	f = open(filename, "r")
	while f.readline():
		count = count + 1
	return count
