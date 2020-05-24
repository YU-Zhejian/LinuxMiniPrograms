#LIBMKTEMP.py V1
import os
def mktemp(S:str)->str:
    mktmp_hand = os.popen('mktemp -t '+S)
    tmpf = mktmp_hand.read().strip()
    mktmp_hand.close()
    return tmpf
