# LIBDO_MONITOR.py V1
import psutil,os,sys,time,datetime
SHELL_PID=int(sys.argv[1])
SHELL_PROC = psutil.Process(SHELL_PID)

print('''
# CPU: Percentage
# MEM:
	Total: total physical memory (exclusive swap).
	ImmAvail: the memory that can be given instantly to processes without the system going into swap.
''')
def now() -> str:
	return str(datetime.datetime.now())+' '

while True:
	time.sleep(0.01)
	#print(now()+'CurrentCPU: '+','.join([str(x) for x in psutil.cpu_percent(interval=None, percpu=True)]))
	#cmem=psutil.virtual_memory()
	#print(now()+'CurrentMEM: '+'Total='+str(cmem.total)+',ImmAvail='+str(cmem.available)+',AvailPer='+str(cmem.percent)+',Buffer='+str(cmem.buffers)+',Cached='+str(cmem.cached)+',Shared='+str(cmem.shared))
	#cmem = psutil.swap_memory()
	#print(now() + 'CurrentSWAP: ' + 'Total=' + str(cmem.total) + ',ImmAvail=' + str(cmem.free) + ',AvailPer=' + str(cmem.percent))
	tsp = now()
	try:
		ptable=SHELL_PROC.children(recursive=True)
	except psutil.Error:
		exit(0)
	for subp in ptable:

		print(tsp +str(subp.pid)+ ':'+','.join(["EXE="+subp.exe(),"CMD="+' '.join(subp.cmdline()),"STAT="+subp.status(),"CWD="+subp.cwd(),"OnCPU="+str(subp.cpu_num()),"%CPU="+str(subp.cpu_percent()),"VIRTMEM="+str(subp.memory_info().vms),"NICE="+str(subp.nice()),"nTHREAD="+str(subp.num_threads()),"nREAD="+str(subp.io_counters().read_count),"nWRITE="+str(subp.io_counters().write_count),"READ_bytes="+str(subp.io_counters().read_bytes),"WRITE_bytes="+str(subp.io_counters().write_bytes)]))
		for x in subp.open_files():
			print(tsp + str(subp.pid) + ':FILES:' + ','.join(["PATH="+x.path,"FD="+str(x.fd),"MODE="+x.mode]))
