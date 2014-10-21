__author__ = 'Beibeihome'

from Modules.kegg_parse import *
from mongoengine import *
import re
import os
import string
import CONSTANT


class Module(DynamicDocument):

    ID = IntField()
    NAME = StringField()
    REACTION = ListField(StringField(), default=[])

    meta = {
        'collection': 'node'
    }

    def name_set(self, text):
        if 'Pathway' in text:
            self.SUBTYPE = 'Pathway'
        elif 'Complex' in text:
            self.SUBTYPE = 'Complex'
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

    def orthology_set(self, text):
        protein_list = re.findall(r"K\d{5}", text)
        #for protein in protein_list:
        #    if protein
        self.ORTHOLOGY = protein_list

    def reaction_set(self, text):
        reaction_list = re.findall(r"R\d{5}", text)
        self.REACTION = reaction_list

    def data_save(self, dict):
        #id_database = count.objects.filter(type='node')[0]
        #self.ID = id_database['value']
        #id_database['value'] += 1
        #id_database.save()
        self.TYPE = 'Module'
        for key in dict:
            text = dict[key]
            if ('Pathway' not in dict['ENTRY']) and ('Complex' not in dict['ENTRY']):
                continue
            if key == 'ENTRY':
                self.name_set(text)
            elif key == 'REFERENCE':
                self.reference_set(text)
            elif key == 'ORTHOLOGY':
                self.orthology_set(text)
            elif key == 'REACTION':
                self.reaction_set(text)
            elif key == 'NAME':
                self.normal_set('NAME_KEGG', text)
            else:
                self.normal_set(key, text)


def main():
    #This path is based on manage.py
    BASEPATH = './kegg/module/'
    connect('igemdata_new', host='mongodb://product:bXYtvBHrSdbuTMETSVO4VTWGl0oeddBHp3hPNsUbEZOEpRFLcqgaYAjHRirnSI@us-ce-0:27017,cn-ah-0:27017,cn-bj-0:27017', replicaSet='replset')
    #save the paths of .cvs files
    paths = []
    for filelist in os.listdir(BASEPATH):
        filepath = os.path.join(BASEPATH, filelist)
        if '.xml' in filepath:
            paths.append(filepath)

    for path in paths:
        fp = file(path, 'rU')
        parse_dict = kegg_split(fp)
        node = Module()
        node.data_save(parse_dict)
        if node['NAME'] is None:
            continue
        node.save()
        fp.close()
        print node.NAME + ' has saved successfully'


main()
