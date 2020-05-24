#LIBISOPT.py V3
import re
my_opt=re.compile(r'-[^-\s]|--\S+|-[^-\s]\:\S+|--\S+:\S+')
def isopt(S:str)->bool:
    if len(my_opt.match(S).group())!=0:
        return True
    else:
        return False
