#!/usr/bin/env python
# VERSION=3.1
"""
Python version of lib/libisopt, includes utilities to judge whether an argument
is an option.
See 'yldoc libisopt' for more details.
"""
import re

my_opt = re.compile(r'-[^-\s]|--\S+|-[^-\s]\:\S+|--\S+:\S+')


def isopt(arguments: str) -> bool:
    """
    Is it an option?
    :param arguments: What needed to be judged.
    :return: Whether it is an option.
    """
    return bool(my_opt.match(arguments))
