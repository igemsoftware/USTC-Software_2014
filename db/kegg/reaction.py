__author__ = 'feiyicheng'

from Modules.kegg_parse import node, link, kegg_split
import re
import os
from Modules.convert_to_mongodb import *
from mongoengine import *
import CONSTANT


class count(Document):
    type = StringField()
    value = IntField()


def handle_equation(field_value, dic):
    equation = field_value[1]
    reactants_str = re.split(r'<=>', equation)[0]
    products_str = re.split(r'<=>', equation)[1]
    reactants = re.findall(r'[A-Z]\d+', reactants_str)
    products = re.findall(r'[A-Z]\d+', products_str)
    dic['REACTANTS'] = reactants
    dic['PRODUCTS'] = products


def handle_enzyme(field_value, dic):
    enzyme_list = re.findall('\d+.\d+.\d+.\d+', field_value[1])
    dic['ENZYME'] = []
    for enzyme in enzyme_list:
        name = 'EC ' + enzyme
        dic['ENZYME'].append(name)


def to_dict(fp):
    dic = {}
    line = fp.readline()
    line = line.replace('\n', '')
    #first line
    if line:
        field_value_type = re.split(r' +', line)
        #print str(field_value_type)
        if len(field_value_type) == 3:
            dic[field_value_type[0]] = field_value_type[1]
            dic['TYPE'] = 'Reaction'
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
        if field_value[0] == 'ENZYME':
            handle_enzyme(field_value, dic)
            #print dic
        elif len(field_value) == 2:
            if field_value[0]:
                dic[field_value[0].upper()] = field_value[1]
            else:
                dic[field.upper()] = field_value[1]

        else:
            print 'ERRORhehe! ' + str(len(field_value))
        line = fp.readline()
        line = line.replace('\n', '')

    return dic


def save_to_database(dic, Doc):
    d = Doc()
    ##ID counter operation
    counter = count.objects.filter(type='node')[0]
    d.ID = counter['value']
    counter['value'] += 1
    counter.save()

    for key in dic.keys():
        if key == 'ENTRY':
            d.NAME = dic['ENTRY']
        elif key == 'NAME':
            d.NAME_KEGG = dic['NAME']
        else:
            exec 'd.%s = dic[key]' % key
        d.EDGE = []
    d.save()
    #print str(d.NAME) + ' saved successfully!'


def main():
    connect(CONSTANT.DATABASE)

    basepath = './kegg/reaction'
    paths = get_dirs(basepath)
    filecount = 0
    for path in paths:
        if path.endswith('xml'):
            filecount += 1
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
            #dic = kegg_split(fp)
            #print dic
            save_to_database(dic, node)
            fp.close()

    print str(filecount) + ' reaction has been processed'

main()

