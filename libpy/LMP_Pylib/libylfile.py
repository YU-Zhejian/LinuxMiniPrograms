# VERSION=1.1
'''
Include utils to deal with files.
'''
import os

from LMP_Pylib.libstr import errh


def ylread(filename: str) -> str:
    '''
    Read a text and return its contents.
    :param filename: The file you need to read. Use '-' or '/dev/stdin' to read
    from standard input.
    :return: The contents inside a file.
    WARNING: This function is intended for SMALL files only.
    '''
    if filename == '-':
        filename = '/dev/stdin'
    if filename != '/dev/stdin' and not os.path.isfile(filename):
        errh('File ' + filename + ' invalid')
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
    '''
    Write files.
    :param filename: The file you need to write.
    :param contents: What needed to be written.
    WARNING: Will overwrite what is inside the file.
    '''
    fh = open(filename, 'w')
    fh.write(contents)
    fh.close()


def yldo(cmd: str) -> str:
    '''
    Execute a command and return its standard output.
    :param cmd: What needed to be executed.
    :return: Its standard output.
    '''
    ret_hand = os.popen(cmd)
    ret = ret_hand.read().strip()
    ret_hand.close()
    return ret


def mktemp(S: str) -> str:
    '''
    A function used to replace 'mktemp' under GNU/Linux. Can create temporary
    files under /tmp. See 'man mktemp' for more details.
    :param S: The path template. e.g. libdo_man.XXXXXX The tailing X will be
    replaced by random numbers.
    :return: The path of temporary file.
    WARNING: This function DO NOT remove the file it creates. You need to remove
    it manually.
    '''
    return yldo('mktemp -t ' + S)


def pywcl(filename: str) -> int:
    '''
    A function used to replace 'wc -l' under GNU/Linux. Have the capacity to
    read large files.
    :param filename: The filename you need to read Use '-' or '/dev/stdin' to
    read from standard input.
    :return: Line numbers.
    '''
    count = 0
    f = open(filename, 'r')
    while f.readline():
        count = count + 1
    return count
