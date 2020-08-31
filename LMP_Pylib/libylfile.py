#LIBYLFILE.py V1
import os
def ylread(filename:str)->str:
	if not os.path.isfile(filename):
		print("\033[31mERROR: File "+filename+" invalid.\033[0m")
		raise FileNotFoundError
	fh=open(filename)
	rets=fh.read().strip()
	fh.close()
	return rets

def ylreadline(filename:str):
	return ylread(filename).strip().split('\n')

def ylwrite(filename:str,contents:str):
	fh = open(filename, 'w')
	fh.write(contents)
	fh.close()

def yldo(cmd:str)->str:
	ret_hand = os.popen(cmd)
	ret = ret_hand.read().strip()
	ret_hand.close()
	return ret

def mktemp(S:str)->str:
	return yldo('mktemp -t '+S)

def pywcl(filename:str)->int:
	count = 0
	f = open(filename, "r")
	for line in f.readlines():
		count = count + 1
	return count
