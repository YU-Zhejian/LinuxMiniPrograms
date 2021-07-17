#!/usr/bin/env python
'''
To test whether a URL is valid.
'''
VERSION = 1.1
import sys

from linuxminipy.libstr import is_url


def main():
    if is_url(sys.argv[1]):
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == '__main__':
    main()
