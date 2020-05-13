#!/usr/bin/env python
#LIBISOPT.py V1
import re
def isopt(S:str)->bool:
    if len(re.match(r'-?|--.+|-?\:.+|--.+:.+',S).group())!=0:
        return True
    else:
        return False
