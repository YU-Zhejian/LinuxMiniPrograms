# LIBDO_MONITOR.py V1
import psutil,os,sys,time,datetime,signal
from LMP_Pylib.libylfile import *
def _term_handler():
	exit(0)

signal.signal(signal.SIGINT,_term_handler)
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
	print(now()+'CurrentCPU: '+','.join([str(x) for x in psutil.cpu_percent(interval=0.2, percpu=True)]))
	cmem=psutil.virtual_memory()
	print(now()+'CurrentMEM: '+','.join(['Total='+str(cmem.total),'ImmAvail='+str(cmem.available),'AvailPer='+str(cmem.percent),'Buffer='+str(cmem.buffers),'Cached='+str(cmem.cached),'Shared='+str(cmem.shared)]))
	cmem = psutil.swap_memory()
	print(now() + 'CurrentSWAP: ' + 'Total=' + str(cmem.total) + ',ImmAvail=' + str(cmem.free) + ',AvailPer=' + str(cmem.percent))
	tsp = now()
	try:
		ptable=SHELL_PROC.children(recursive=True)
		for subp in ptable:
			print(tsp + str(subp.pid) + ':INFO:' + ','.join(["EXE=" + subp.exe(), "CMD=" + ' '.join(subp.cmdline()), "STAT=" + subp.status(), "CWD=" + subp.cwd(), "OnCPU=" + str(subp.cpu_num()), "%CPU=" + str(subp.cpu_percent(0.2)),  "NICE=" + str(subp.nice())]))
			print(tsp + str(subp.pid) + ':MEM:' + ','.join(["Residential=" + str(subp.memory_info().rss), "Virtual=" + str(subp.memory_info().vms), "Shared=" + str(subp.memory_info().shared), "text=" + str(subp.memory_info().text), "data=" + str(subp.memory_info().data)]))
			#print(tsp + str(subp.pid) + ':IO:' + ','.join(["nREAD=" + str(subp.io_counters().read_count), "nWRITE=" + str(subp.io_counters().write_count), "READ_bytes=" + str(subp.io_counters().read_bytes), "WRITE_bytes=" + str(subp.io_counters().write_bytes)]))
			#print(tsp + str(subp.pid) + ':IO:' +yldo('pidstat -d -p '+str(subp.pid)+r''' |tail -n 1| awk '{OFS=",";print "READ="$4,"WRITE="$5,"DELLAY="$7}' '''))
			for x in subp.open_files():
				print(tsp + str(subp.pid) + ':FILES:' + ','.join(["PATH=" + x.path, "FD=" + str(x.fd), "MODE=" + x.mode]))
			for x in subp.threads():
				subt = psutil.Process(x.id)
				print(tsp + str(subp.pid) + ':THREADS:' + ','.join(["PID=" + str(subt.pid), "OnCPU=" + str(subt.cpu_num())]))
				#print(tsp + str(subp.pid) + ':IO:PID=' + str(subt.pid) + ','+ yldo('pidstat -d -p ' + str(subt.pid) + r''' |tail -n 1| awk '{OFS=",";print "READ="$4,"WRITE="$5,"DELLAY="$7}' '''))
	except psutil.Error:
		exit(0)
