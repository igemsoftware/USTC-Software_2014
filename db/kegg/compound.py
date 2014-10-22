__author__ = 'Beibeihome'

from Modules.kegg_parse import *
from mongoengine import *
import os
import string
import re
import threading
import CONSTANT


class Compound(DynamicDocument):
    ID = IntField()
    NAME = StringField()
    NAME_KEGG = StringField()
    SYSNAME = ListField(StringField())
    EXACT_MASS = FloatField()
    MOL_WEIGHT = FloatField()
    REMARK = StringField()
    REFERENCE = ListField(StringField())
    EDGE = ListField(ReferenceField(link), default=[])

    meta = {
        'collection': 'node'
    }

    def name_set(self, text):
        text = text.rstrip(string.letters + ' \n')
        self.NAME = text.lstrip()

    def kegg_name_set(self, text):
        text = text.replace(' ', '')
        text = text.replace('\n', '')
        text = text.split(';')
        self.NAME_KEGG = text[0]
        self.SYSNAME = text[1:]

    def normal_set(self, field, text):
        text = text.replace(' ', '')
        order = 'self.' + field + ' = text'
        exec order

    def float_set(self, field, text):
        text = text.strip()
        text = float(text)
        order = 'self.' + field + ' = text'
        exec order

    def reference_set(self, text):
        text = text.strip()
        text = ''.join([' ', text])
        text = re.split('[\s][\d][\s]', text)
        for log in text:
            log = log.strip()
        text.remove('')
        self.REFERENCE = text

    def data_save(self, dict):
        self.TYPE = 'Compound'
        for key in dict:
            text = dict[key]
            if key == 'ENTRY':
                self.name_set(text)
            elif key in ['EXACT_MASS', 'MOL_WEIGHT']:
                self.float_set(key, text)
            elif key == 'REFERENCE':
                self.reference_set(text)
            elif key == 'NAME':
                self.kegg_name_set(text)
            else:
                self.normal_set(key, text)


class c_importing_thread(threading.Thread): #The timer class is derived from the class threading.Thread

    connect('igemdata_new', host='mongodb://product:bXYtvBHrSdbuTMETSVO4VTWGl0oeddBHp3hPNsUbEZOEpRFLcqgaYAjHRirnSI@us-ce-0:27017,cn-ah-0:27017,cn-bj-0:27017', replicaSet='replset')

    def __init__(self, path_list, num):
        threading.Thread.__init__(self)
        self.path_list = path_list
        self.num = num
        self.thread_stop = False

    def run(self):  # Overwrite run() method, put what you want the thread do here
        while self.path_list:
            path = self.path_list.pop()
            fp = file(path, 'rU')
            parse_dict = kegg_split(fp)
            node = Compound()
            node.data_save(parse_dict)
            node.save()
            fp.close()
            print path + ' has saved successfully from thread ' + str(self.num)
        else:
            self.stop()

    def stop(self):
        self.thread_stop = True


def main():
    BASEPATH = './kegg/compound/'
    #BASEPATH = './compound/'
    connect('igemdata_new', host='mongodb://product:bXYtvBHrSdbuTMETSVO4VTWGl0oeddBHp3hPNsUbEZOEpRFLcqgaYAjHRirnSI@us-ce-0:27017,cn-ah-0:27017,cn-bj-0:27017', replicaSet='replset')
    #save the paths of .cvs files
    paths = []
    for filelist in os.listdir(BASEPATH):
        filepath = os.path.join(BASEPATH, filelist)
        if '.xml' in filepath:
            paths.append(filepath)

    thread1 = c_importing_thread(paths, 1)
    thread2 = c_importing_thread(paths, 2)
    thread3 = c_importing_thread(paths, 3)
    thread4 = c_importing_thread(paths, 4)

    thread1.start()
    thread2.start()
    thread3.start()
    thread4.start()

    """for path in paths:
        #connect(CONSTANT.DATABASE)
        fp = file(path, 'rU')
        parse_dict = kegg_split(fp)
        node = Compound()
        node.data_save(parse_dict)
        node.save()
        fp.close()
        print path + ' has saved successfully'"""

main()
