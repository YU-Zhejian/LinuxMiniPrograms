#!/usr/env/bin python
'''
gitm_add in Python
'''
import os
import sys
import uuid

import libgitm
from linuxminipy.libisopt import isopt
from linuxminipy.libstr import is_url, warnh, infoh, errh

VERSION = 1.0
errh("Too much bugs")


def main():
    STDS = []
    for sysarg in sys.argv[1:]:
        if isopt(sysarg):
            if sysarg in ('-h', '--help'):
                os.system('yldoc git-mirror')
                sys.exit(0)
            elif sysarg in ('-v', '--version'):
                print(str(VERSION) + ' in Python')
                sys.exit(0)
        else:
            STDS.append(sysarg)
    # TODO: lock
    my_uuid_table = libgitm.UuidTable()
    my_gitm_log = libgitm.GitmLog()
    for my_url in STDS:
        my_url.replace('file://', '')
        if not is_url(my_url):
            warnh('Skipping bad URL ' + my_url)
            continue
        if my_uuid_table.findurl(my_url):
            warnh('Skipping existing URL ' + my_url)
        my_uuid = uuid.uuid4().__str__()
        while True:
            if my_uuid_table.finduuid(my_uuid):
                my_uuid = uuid.uuid4()
            else:
                break
        infoh(my_url + ' -> ' + my_uuid)
        if os.system('git clone --mirror --no-hardlinks --verbose --progress \'' + my_url + '\' \'' + my_uuid + '\''):
            my_uuid_table.add(my_url, my_uuid)
            pass
            my_gitm_log.add('t'.join(['ADD', 'SUCCESS', my_url, my_uuid]))
        else:
            warnh(my_url + ' corrupted. Will be skipped"')
            os.remove(my_uuid)
            os.remove("./logs/" + my_uuid)
            my_gitm_log.add('t'.join(['ADD', 'FAILED', my_url, my_uuid]))


if __name__ == '__main__':
    main()
