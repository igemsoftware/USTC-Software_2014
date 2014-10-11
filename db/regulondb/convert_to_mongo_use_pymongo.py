__author__ = 'feiyicheng'

from mongoengine import *
import re
import os
import xlrd
import pymongo
import CONSTANT

#DynamicClass
class Node(DynamicDocument):
   id = IntField(primary_key=True)
    


def dataprocess(fields, line):
    '''split a line into a dict
        pattern is a list
        line is a string
        return a dic
    '''
    metadata = re.split(r'\t', line)
    if len(fields) != len(metadata):
        return None
    for i in xrange(len(metadata)):
        if re.match(r'\s', metadata[i]):
            metadata[i] = ''

    dic = dict((fields[i], metadata[i]) for i in xrange(0, len(fields)))
    return dic

def save_to_database(dic, tag, typ, db):

    """

    :param dic: a dict like {name: value,...}
    :param typ: to insert {type: }
    """
    dic['_id'] = tag
    dic['type'] = typ
    db.link.insert(dic, save=True)


    #link = Link()
    #for key in dic.keys():
    #    exec "link.%s = dic[key]" % key
    #link.type = typ
    #link.save()

def drop_brackets(oldstring):
    re_brackets = re.compile(r'\(.*\)')
    return re_brackets.sub('', oldstring)

def get_dirs(basepath):
    paths = []
    for filelist in os.listdir(basepath):
        filepath = os.path.join(basepath, filelist)
        paths.append(filepath)
    return paths

def get_type(path):
    typ = re.search(r'(?<=link/).*?(?=\.txt)', path)
    if typ:
        return typ.group(0)
    else:
        return None

def is_txt(path):
    if re.search(r'.*txt$', path):
        return True
    else:
        return False

def standardized(strin):
    '''
    replace special characters like(#$*!-) with a underline '_'
    '''
    re_replace = re.compile(r"[ ,\"()+-?*|]{1}|[\[]{1}|[]]{1}|[']{1}")
    return re_replace.sub('_', strin)

def main():
    conn = pymongo.Connection()
    db = conn[CONSTANT.DATABASE]

    basepath = './regulondb/node/'
    paths = get_dirs(basepath)

    tag = 0
    #walk the direction
    for path in paths:
        typ = get_type(path)
        if not typ:
            print "cannot get the type"
            continue
        #open file
        fp = open(path, 'rU')

        #loop on line
        if fp and is_txt(path):


            print 'file '+path+' opened'


            #get the fields
            line = fp.readline()
            line = line.replace('\n', '')

            fields = re.split(r'\t+', line)

            #for i in xrange(len(fields)):
             #   fields[i] = standardized(fields[i])

            print "pattern:  "+str(fields) + '\n'+str(len(fields))+'\n\n'

            while line:
                line = fp.readline()
                if line:
                    if typ == 'Gene':
                        line = drop_brackets(line)
                    if '_' in typ:
                        typ = [fields[0], fields[1]]
                    line = line.replace('\n', '')
                    dic = dataprocess(fields, line)
                    save_to_database(dic, tag, typ, db)
                    tag = tag + 1


def main_2():
    conn = pymongo.Connection()
    db = conn[CONSTANT.DATABASE]

    basepath = './regulondb/link/'
    paths = get_dirs(basepath)

    tag = 0
    #walk the direction
    for path in paths:
        typ = get_type(path)
        if not typ:
            print "cannot get the type"
            continue
            #open file
        fp = open(path, 'rU')

        #loop on line
        if fp and is_txt(path):


            print 'file '+path+' opened'


            #get the fields
            line = fp.readline()
            line = line.replace('\n', '')

            fields = re.split(r'\t+', line)

            #for i in xrange(len(fields)):
            #   fields[i] = standardized(fields[i])

            print "pattern:  "+str(fields) + '\n'+str(len(fields))+'\n\n'

            while line:
                line = fp.readline()
                if line:
                    if typ == 'Gene':
                        line = drop_brackets(line)
                    if '_' in typ:
                        typ = [fields[0], fields[1]]
                    line = line.replace('\n', '')
                    dic = dataprocess(fields, line)
                    save_to_database(dic, tag, typ, db)
                    tag = tag + 1

def main_3():
    connect(CONSTANT.DATABASE)
    basepath = './regulondb/father'
    paths = get_dirs(basepath)
    for path in paths:
        if path.endswith('xlsx'):
            data = xlrd.open_workbook(path)
            table = data.sheets()[0]
            field = table.row_values(0)
            for i in xrange(1, table.nrows):
                group = table.row_values(i)
                father_v = group[0]
                child_v = group[1]
                father_type = field[0]
                child_type = field[1]

                father = Node.objects(NAME=father_v, type=father_type).first()
                child = Node.objects(NAME=child_v, type=child_type).first()
                if father and child:
                    child.father_id = father.id

                    try:
                        child.save()

                        print 'succeed!  ' + 'father_id ' + str(father.id) +'  child_id ' + str(child.id)
                    except :
                        print 'saved failed'
                else:
                    print 'cannot find'


main_2()

