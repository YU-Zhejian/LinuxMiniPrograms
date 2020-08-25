#LIBISOPT.py V3
import re
my_opt=re.compile(r'-[^-\s]|--\S+|-[^-\s]\:\S+|--\S+:\S+')
def isopt(S:str)->bool:
    if my_opt.match(S):
        return True
    else:
        return False
