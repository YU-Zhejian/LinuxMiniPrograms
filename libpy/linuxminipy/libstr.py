# VERSION=1.2
"""
Python version of shlib/libstr, includes common string-output utilities.
See 'yldoc libstr' for more details.
"""
import os
import re
import sys

sshstr = re.compile(r"ssh://([^@\s]+@){0,1}([^@:\s]+)(:[0-9]+){0,1}(/[^@:]*)")
httpstr = re.compile(r"http(s){0,1}://([^@:\s]+)(:[0-9]+){0,1}(/[^@:]*)")
gitstr = re.compile(r"git://([^@:\s]+)(:[0-9]+){0,1}(/[^@:]*)")
scpstr = re.compile(r"([^@\s]+@){0,1}([^@:\s]+):(/[^@:]*)")


def eprint(*args, **kwargs):
    """
    Enhanced print to standard error.
    :param args: What needed to be print.
    :param kwargs: Other arguments supplied to function 'print'.
    """
    print(*args, file=sys.stderr, **kwargs)


def infoh(instr: str):
    eprint("\033[33mINFO:", instr, "\033[0m")


def warnh(instr: str):
    eprint("\033[31mWARNING:", instr, "\033[0m")


def errh(instr: str):
    eprint("\033[31mERROR:", instr, "\033[0m")
    sys.exit(1)


def is_url(inurl: str):
    if sshstr.match(inurl) or gitstr.match(inurl) or \
            scpstr.match(inurl) or os.path.isdir(inurl):
        return True
    else:
        return False
