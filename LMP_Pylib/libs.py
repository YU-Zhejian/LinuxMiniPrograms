#LIBS.py V1P1
import re,os
def isopt(S:str)->bool:
    if len(re.match(r'-?|--.+|-?\:.+|--.+:.+',S).group())!=0:
        return True
    else:
        return False
def mktemp(S:str)->str:
    mktmp_hand = os.popen('mktemp -t '+S)
    tmpf = mktmp_hand.read().strip()
    mktmp_hand.close()
    return tmpf
