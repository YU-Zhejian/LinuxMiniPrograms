__LIBSTR_VERSION=1.2
"""
Python version of shlib/libstr, includes common string-output utilities.
See 'yldoc libstr' for more details.
"""
import os
import re
import sys

ANSI_RED = ""
ANSI_GREEN = ""
ANSI_YELLOW = ""
ANSI_BLUE = ""
ANSI_PURPLE = ""
ANSI_CRAYON = ""
ANSI_CLEAR = ""
# Python can test wheter the output is a tty. Other method have to employ ncurses.

if sys.stdout.isatty() and sys.stderr.isatty():
    ANSI_RED = "\033[31m"
    ANSI_GREEN = "\033[32m"
    ANSI_YELLOW = "\033[33m"
    ANSI_BLUE = "\033[34m"
    ANSI_PURPLE = "\033[35m"
    ANSI_CRAYON = "\033[36m"
    ANSI_CLEAR = "\033[0m"


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
    eprint(ANSI_YELLOW, "INFO:", instr, ANSI_CLEAR)


def warnh(instr: str):
    eprint(ANSI_RED, "WARNING:", instr, ANSI_CLEAR)


def errh(instr: str):
    eprint(ANSI_RED, "ERROR:", instr, ANSI_CLEAR)
    sys.exit(1)


def is_url(inurl: str):
    if sshstr.match(inurl) or gitstr.match(inurl) or \
            scpstr.match(inurl) or os.path.isdir(inurl):
        return True
    else:
        return False
