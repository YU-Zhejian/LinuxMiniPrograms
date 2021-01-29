#!/usr/bin/env python
# AD2U.py V2P2
import re
import sys

fix_tgt = 90


def fix_tail():
	tmp_line = fdoc_out_lines.pop()
	if len(tmp_line) <= fix_tgt:
		fdoc_out_lines.append(tmp_line)
	else:
		tmp_blank_len = len(tmp_line) - len(tmp_line.lstrip())
		blank_pos = tmp_line[fix_tgt:0:-1].find(' ')
		line1 = tmp_line[0:fix_tgt - blank_pos]
		line2 = ' ' * tmp_blank_len + tmp_line[fix_tgt + 1 - blank_pos:]
		fdoc_out_lines.append(line1)
		fdoc_out_lines.append(line2)
		fix_tail()


def GetFullADoc(l: list):
	n = 0
	while n < len(l):
		if re.search('^include\:\:(.+)\[\]', l[n]):
			includefile = open(re.search('^include\:\:(.+)\[\]', l[n]).group(1), 'r')
			include_lines = includefile.readlines()
			includefile.close()
			include_lines = GetFullADoc(include_lines)
			l.pop(n)
			for item in include_lines[::-1]:
				l.insert(n, item)
		n = n + 1
	return l


fadoc_hand = open(sys.argv[1], "r")
fdoc_lines = fadoc_hand.readlines()
fadoc_hand.close()
fdoc_out_lines = []
Currindent = ''
fdoc_lines = GetFullADoc(fdoc_lines)
for i in range(len(fdoc_lines) - 1, -1, -1):
	fdoc_lines[i] = fdoc_lines[i].strip()
	if fdoc_lines[i] == '' or fdoc_lines[i].startswith(r'image::') or re.match(r'^\:.+\:.*$', fdoc_lines[i]):
		fdoc_lines.pop(i)
for line in fdoc_lines:
	if line == r"----" and Currindent.__contains__(r'| '):
		Currindent = Currindent[0:-2]
		fdoc_out_lines.append('')
	elif Currindent.__contains__(r'| '):
		fdoc_out_lines.append(Currindent + line)
	elif line == r"----":
		Currindent = Currindent + r'| '
		fdoc_out_lines.append('')
	elif line.startswith(r'='):
		reeq = re.match(r'=*=', line).span()
		Currindent = '	' * (reeq[1] - reeq[0] - 1)
		fdoc_out_lines.append('	' * (reeq[1] - reeq[0] - 2) + line.replace('=', '').strip())
		fdoc_out_lines.append('')
	elif line.startswith(r'*'):
		reeq = re.match(r'\**\*', line).span()
		fdoc_out_lines.append(Currindent + '	' * (reeq[1] - reeq[0]) + r'* ' + line.replace('*', '').strip())
		fix_tail()
		fdoc_out_lines.append('')
	elif line.startswith(r'.'):
		reeq = re.match(r'\.*\.', line).span()
		fdoc_out_lines.append(Currindent + '	' * (reeq[1] - reeq[0]) + r'- ' + line.replace('.', '').strip())
		fix_tail()
		fdoc_out_lines.append('')
	else:
		fdoc_out_lines.append(Currindent + line)
		fix_tail()
		fdoc_out_lines.append('')
dochead = sys.argv[1][:-5:]
blank_len = (fix_tgt - 13 - len(dochead)) // 2
fdoc_out_lines.insert(0, '')
fdoc_out_lines.insert(0, 'YuZJLab' + ' ' * blank_len + dochead + ' ' * blank_len + 'MANUAL')
fdoc_out_lines.append('YuZJLab' + ' ' * 34 + '2019-2021' + ' ' * 34 + 'MANUAL')
fdoc_out_handle = open(sys.argv[2], 'w')
for line in fdoc_out_lines:
	fdoc_out_handle.write(line.rstrip() + '\n')
fdoc_out_handle.close()
