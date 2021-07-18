#!/usr/bin/env python
# -*- coding: utf-8 -*-
# VERSION=3.2
"""
Python version of lib/libisopt, includes utilities to judge whether an argument
is an option.
See 'yldoc libisopt' for more details.
"""
import re

my_opt = re.compile(r'^-[^-\s]|--[^-\s]+|-[^-\s]:[^-\s]+|--[^-\s]+:[^-\s]+$')


def isopt(arguments: str) -> bool:
    """
    Is it an option?
    :param arguments: What needed to be judged.
    :return: Whether it is an option.
    """
    return bool(my_opt.match(arguments))
