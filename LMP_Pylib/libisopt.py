#LIBISOPT.py V2
import re
my_opt=re.compile(r'-?|--.+|-?\:.+|--.+:.+')
hlp_opt=re.compile('r-h|--help')
ver_opt=re.compile('r-v|--version')
def isopt(S:str)->bool:
    if len(my_opt.match(S).group())!=0:
        return True
    else:
        return False
