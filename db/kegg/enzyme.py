__author__ = 'Beibeihome'

from mongoengine import *
import os
import string
import re
from Modules.kegg_parse import *
import pymongo
import CONSTANT

class Enzyme(DynamicDocument):
    ID = IntField()
    NAME = StringField()
    TYPE = StringField()
    NAME_KEGG = StringField()
    EDGE = ListField(ReferenceField(link), default=[])
    CLASS = StringField()
    REACTION = StringField()
    SUBSTRATE = StringField()
    PRODUCT = StringField()
    REFERENCE = ListField(StringField())
    #REFERENCE = StringField()
    ORTHOLOGY = StringField()
    GENES = ListField(StringField())
    DBLINKS = StringField()

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

    def data_save(self, dict):
        self.TYPE = 'Enzyme'
        for key in dict:
            text = dict[key]
            if key == 'ENTRY':
                self.name_set(text)
            elif key == 'REFERENCE':
                self.reference_set(text)
            elif key == 'GENES':
                self.genes_set(text)
            elif key == 'NAME':
                self.normal_set('NAME_KEGG', text)
            else:
                self.normal_set(key, text)


def non_eco_enzyme_delete():

    module_list = node.objects.filter(TYPE='Enzyme')
    for enzyme_to_delete in module_list.filter(GENES=[]):
        enzyme_to_delete.delete()
    print 'Non-ECO enzymes have been deleted'


def main():
    BASEPATH = './kegg/enzyme/'
    #save the paths of .cvs files
    paths = []
    for filelist in os.listdir(BASEPATH):
        filepath = os.path.join(BASEPATH, filelist)
        if '.xml' in filepath:
            paths.append(filepath)
    count = 0
    for path in paths:
        fp = file(path, 'rU')
        parse_dict = kegg_split(fp)
        node = Enzyme()
        node.data_save(parse_dict)
        node.save()
        fp.close()
        #print path + ' has saved successfully'
        count += 1

    ## Keep the Enzyme which appear in ECO

    non_eco_enzyme_delete()


main()




