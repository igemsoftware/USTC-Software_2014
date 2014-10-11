__author__ = 'feiyicheng'

import Modules.kegg_parse
import re
import os
from Modules.convert_to_mongodb import *
import pymongo
import CONSTANT


def handle_equation(field_value, dic):
    equation = field_value[1]
    reactants_str = re.split(r'<=>', equation)[0]
    products_str = re.split(r'<=>', equation)[1]
    reactants = re.findall(r'[A-Z]\d+', reactants_str)
    products = re.findall(r'[A-Z]\d+', products_str)
    dic['reactants'] = reactants
    dic['products'] = products


def to_dict(fp):
    dic = {}
    line = fp.readline()
    line = line.replace('\n', '')
    #first line
    if line:
        field_value_type = re.split(r' +', line)
        print str(field_value_type)
        if len(field_value_type) == 3:
            dic[field_value_type[0]] = field_value_type[1]
            dic['type'] = field_value_type[2]
            field = field_value_type[0]
        else:
            print 'ERRORhaha!'

    line = fp.readline()
    line = line.replace('\n', '')
    while line and not line.startswith('///'):
        field_value = re.split(r' +', line, maxsplit=1)
        if field_value[0]:
            field = field_value[0]
            #deal with EQUATION
        if field_value[0] == 'EQUATION':
            handle_equation(field_value, dic)
        if len(field_value) == 2:
            if field_value[0]:
                dic[field_value[0]] = field_value[1]
            else:
                dic[field] = field_value[1]

        else:
            print 'ERRORhehe! '+ str(len(field_value))
        line = fp.readline()
        line = line.replace('\n', '')

    return dic


def save_to_database(dic, db):
    count = int(db.count.find_one({'type': 'node'})['value'])
    dic['ID'] = count + 1
    dic['TYPE'] = 'Reaction'
    db.node.insert(dic)
    db.count.update({'type': 'node'}, {'$inc': {'value': 1}})  # count +1
    print 'saved successfully!'


def main():
    conn = pymongo.Connection()
    db = conn[CONSTANT.DATABASE]


    basepath = '/Users/feiyicheng/Documents/igem-backend/origin_data/kegg/reaction'
    paths = get_dirs(basepath)
    for path in paths:
        if path.endswith('xml'):
            fp = open(path, 'rU')
            '''
            line = fp.readline()
            while line:
                if line:
                    line = line.replace('\n', '')
                    print line
                    line = fp.readline()
            '''
            dic = to_dict(fp)
            save_to_database(dic, db)
            fp.close()

