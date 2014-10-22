__author__ = 'Beibeihome'

from Modules.kegg_parse import kegg_split
from mongoengine import *
import re
import os
import string
import CONSTANT


class count(Document):
    type = StringField()
    value = IntField()


class Protein(DynamicDocument):
    ID = IntField()
    NAME = StringField()
    ECNAME = StringField(default='')
    TYPE = StringField(default='Protein')
    GENES = ListField(StringField(), default=[])

    meta = {
        'collection': 'node'
    }

    def name_set(self, text):
        text = text.rstrip(string.letters + ' \n')
        self.NAME = text.lstrip()

    def normal_set(self, field, text):
        text = text.replace(' ', '')
        order = 'self.' + field + ' = text'
        exec order

    def reference_set(self, text):
        text = text.strip()
        text = ''.join([' ', text])
        text = re.split('[\s][\d][\s]', text)
        for log in text:
            log = log.strip()
        if '' in text:
            text.remove('')
        self.REFERENCE = text

    def genes_set(self, text):
        # Now only for Ecoli
        # Can change 'ECO' to string and fix here and there to make it complete
        if 'ECO:' in text:
            text = text[text.index('ECO:'):]
            line = ''
            gene_list = []
            for letter in text:
                line = ''.join([line, letter])
                if letter == '\n':
                    break
            gene_list = re.findall(r"\((.{2,4})\)", line)
            self.GENES = gene_list

    def ecentry_set(self, text):
        ec_name = ''
        if '[' in text:
            ec_name = text.split('[')[1]
            ec_name = ec_name.replace(':', ' ')
            ec_name = ec_name.rstrip(']')
            ec_name = ec_name.strip()
            self.ECENTRY = ec_name
        self.DEFINITION = text.split('[')[0].strip()

    def data_save(self, dict):
        self.TYPE = 'Protein'
        for key in dict:
            text = dict[key]
            if key == 'ENTRY':
                self.name_set(text)
            elif key == 'REFERENCE':
                self.reference_set(text)
            elif key == 'GENES':
                self.genes_set(text)
            elif key == 'DEFINITION':
                self.ecentry_set(text)
            elif key == 'NAME':
                self.normal_set('NAME_KEGG', text)
            else:
                self.normal_set(key, text)


def main():
    BASEPATH = './kegg/protein/'
    connect('igemdata_new', host='mongodb://product:bXYtvBHrSdbuTMETSVO4VTWGl0oeddBHp3hPNsUbEZOEpRFLcqgaYAjHRirnSI@us-ce-0:27017,cn-ah-0:27017,cn-bj-0:27017', replicaSet='replset')
    #save the paths of .cvs files
    paths = []
    for filelist in os.listdir(BASEPATH):
        filepath = os.path.join(BASEPATH, filelist)
        if '.xml' in filepath:
            paths.append(filepath)

    for path in paths:
        fp = file(path, 'rU')
        text = fp.read()
        fp.seek(0)
        parse_dict = kegg_split(fp)
        if 'RNA' in parse_dict['ENTRY']:
            continue
        node = Protein()
        node.data_save(parse_dict)
        if 'transport' in text or 'Transport' in text:
            node.TRANSPORT = True
        else:
            node.TRANSPORT = False
        node.save()
        fp.close()
        print path + ' has saved successfully'


main()