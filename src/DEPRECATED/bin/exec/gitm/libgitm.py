'''
Common gitm libs
'''
import datetime


class UuidTable:
    def __init__(self):
        pass

    def add(self, my_url: str, my_uuid: str):
        pass

    def findurl(self, my_url: str):
        pass

    def finduuid(self, my_uuid: str):
        pass


class GitmLog:
    def __init__(self):
        pass

    def add(self, msg_str: str):
        addstr = '\t'.join([datetime.date.today().strftime('+%Y-%m-%d %H:%M:%S'), msg_str])
        pass
