'''This program is to handle mm.txt in the module directory'''
__author__ = 'Beibeihome'

import re
from mongoengine import *
import pymongo
import CONSTANT
from CONSTANT import db


class Module_Function_link(Document):
    #MODULE = StringField()
    FUNCTION = StringField()
    MODULE = ListField(StringField())


def delete_module():
    db.node.remove({'TYPE': 'Module'})


def parse():
    connect('igemdata_new', host='mongodb://product:bXYtvBHrSdbuTMETSVO4VTWGl0oeddBHp3hPNsUbEZOEpRFLcqgaYAjHRirnSI@us-ce-0:27017,cn-ah-0:27017,cn-bj-0:27017', replicaSet='replset')
    PATH = './kegg/module/mm.txt'
    fp = file(PATH, 'rU')
    #function dict save the informatino between function and module
    function_dict = {}
    for line in fp:
        if 'Structural complex' in line:
            break
        if '%' in line:
            function = re.findall(r'%(.*)%', line)[0]
            function_dict[function] = []
        elif 'M' in line:
            module = re.findall(r'M\d{5}', line)[0]
            function_dict[function].append(module)
    for function in function_dict:
        m_f_link = Module_Function_link()
        m_f_link.FUNCTION = function
        m_f_link.MODULE = function_dict[function]
        m_f_link.save()
        print function + ' has been saved successfully'


def main():
    count = 0
    for log in db.module__function_link.find():
        #module_list = db.kegg_node.find({'TYPE': 'Module'})
        ### Some Module doesn't have REACTION attribute, so if yixia
        for module in db.node.find({'NAME': {'$in': log['MODULE']}}):
            if module['SUBTYPE'] == 'Pathway':
                if 'REACTION' not in module.keys():
                    continue
                reaction_list = module['REACTION']
                for reaction in reaction_list:
                    db.reaction.update({'NAME': reaction}, {'$set': {'FUNCTION': log['FUNCTION']}})
                    print str(count) + ' update successfully'
                    count += 1
            else:
                continue
    print 'All update successfully'

    #delete_module()


parse()
main()