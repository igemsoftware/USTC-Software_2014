__author__ = 'feiyicheng'

import os
import re
import pymongo
import xlrd
import CONSTANT
from pymongo.mongo_replica_set_client import MongoReplicaSetClient

client = MongoReplicaSetClient('mongodb://product:bXYtvBHrSdbuTMETSVO4VTWGl0oeddBHp3hPNsUbEZOEpRFLcqgaYAjHRirnSI@us-ce-0:27017,cn-ah-0:27017,cn-bj-0:27017', replicaSet='replset')
db = client[CONSTANT.DATABASE]

def get_base_path():
    return raw_input("input base path:")


def get_dirs(basepath):
    paths = []
    for filelist in os.listdir(basepath):
        filepath = os.path.join(basepath, filelist)
        paths.append(filepath)
    return paths


def is_txt(path):
    if re.search(r'.*txt$', path):
        return True
    else:
        return False

def is_excel(path):
    if re.search(r'.*xlsx$', path):
        return True
    else:
        return False

def get_file_name(path, father):
    typ = None
    exec "typ = re.search(r'(?<=%s/).*?(?=\.txt)', path)" % (father,)
    if typ:
        if father != 'link':
            return typ.group(0)
        elif father == 'link':
            return typ.group(0).split('_')
        else:
            raise NameError

    else:
        return None


def drop_brackets(oldstring):
    re_brackets = re.compile(r'\(.*\)')
    return re_brackets.sub('', oldstring)


def save_data(collection, path, type, file_type):
    if file_type == 'txt':
        save_data_txt(collection, path, type)
    elif file_type == 'excel':
        save_data_xlsx(path, type)
    else:
        pass


def save_data_txt(collection, path, typ):
    fp = open(path, 'rU')
    line_fields = fp.readline()
    line_fields = line_fields.replace('\n', '')
    fields = line_fields.split('\t')

    line = fp.readline()
    line = line.replace('\n', '')
    while line:
        item = line2dict(fields, line)
        savedict(item, typ, collection)

        line = fp.readline()
        line = line.replace('\n', '')


def save_data_xlsx(collection, path, typ):
    pass


def line2dict(fields, line):
    values = line.split('\t')
    dic = {}
    if fields[0] == 'TU' or fields[1] == 'TU':
        values[0] = values[0].split('[')[0]
        values[1] = values[1].split('[')[0]
    for i in xrange(len(fields)):
        dic[fields[i]] = values[i]
    return dic


def savedict(dic, typ, collection):
    if collection == 'node':
        count = int(db.count.find_one({'type': 'node'})['value'])
        dic['ID'] = count + 1
        dic['TYPE'] = typ
        #SPECIAL
        if typ == 'Gene':
            dic['NAME'] = drop_brackets(dic['NAME'])

        # Make sure about only one log with same NAME
        if db.node.find_one({'NAME': dic['NAME'], 'TYPE': dic['TYPE']}) or dic['NAME'] == '' or dic['NAME'] == 'Phantom Gene':
            #print 'NAME: ' + dic['NAME'] + '  TYPE: ' + dic['TYPE']
            return -1

        exec "db.%s.insert(dic)" % (collection, )
        del dic
        db.count.update({'type': 'node'}, {'$inc': {'value': 1}})  # nodecount +1
    elif collection == 'link':
        count = int(db.count.find_one({'type': 'link'})['value'])
        dic['ID'] = count + 1
        dic['TYPE1'] = typ[0]
        dic['TYPE2'] = typ[1]
        dic['NODE1'] = None
        dic['NODE2'] = None
        exec "db.%s.insert(dic)" % (collection, )
        del dic
        db.count.update({'type': 'link'}, {'$inc': {'value': 1}})  # linkcount +1
    elif collection == 'product':
        count = int(db.count.find_one({'type': 'product'})['value'])
        dic['ID'] = count + 1
        dic['TYPE'] = dic['Product Type']
        if dic['TYPE'] == '-':
            dic['TYPE'] = 'Protein'
        if dic['TYPE'] == 'small RNA':
            dic['TYPE'] = 'sRNA'
        exec "db.%s.insert(dic)" % (collection, )
        dic.pop('_id')
        db.count.update({'type': 'product'}, {'$inc': {'value': 1}})  # productcount +1

        # sRNA and tRNA and rRNA
        if dic['Product Type'] in ['small RNA', 'tRNA', 'rRNA']:
            TYPE = dic['Product Type']
            if dic['Product Type'] == 'small RNA':
                TYPE = 'sRNA'
            nodecount  = int(db.count.find_one({'type': 'node'})['value'])
            dic['ID'] = nodecount + 1
            dic['TYPE'] = TYPE
            exec "db.%s.insert(dic)" % (collection, )
        db.count.update({'type': 'node'}, {'$inc': {'value': 1}})  # nodecount +1
    else:
        return


def add_ref_father(path):
    if path.endswith('xlsx'):
        data = xlrd.open_workbook(path)
        table = data.sheets()[0]
        field = table.row_values(0)
        for i in xrange(1, table.nrows):
            group = table.row_values(i)
            father_name = group[0]
            child_name = group[1]
            father_type = field[0]
            child_type = field[1]
            father = db.node.find_one({'TYPE': father_type, 'NAME': father_name})
            child = db.node.find_one({'TYPE': child_type, 'NAME': child_name})
            if (not father) or (not child):
                #print "not found"
                continue
            # add father id to child
            if not child.has_key('FATHER'):
                db.node.update({'TYPE': child_type, 'NAME': child_name}, {"$push": {"FATHER": father['_id']}})
            else:
                if not father['_id'] in child['FATHER']:
                    db.node.update({'TYPE': child_type, 'NAME': child_name}, {"$push": {"FATHER": father['_id']}})

            # add child id to father
            if not father.has_key('CHILD'):
                db.node.update({'TYPE': father_type, 'NAME': father_name}, {"$push": {"CHILD": child['_id']}})
            else:
                if not child['_id'] in father['CHILD']:
                    db.node.update({'TYPE': father_type, 'NAME': father_name}, {"$push": {"CHILD": child['_id']}})
            #print 'child: ' + str(child['ID']) + '  father: ' + str(father['ID'])
