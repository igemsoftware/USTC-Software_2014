__author__ = 'feiyicheng'

from mongoengine import *
import re
import os
import xlrd
import CONSTANT

#DynamicClass
class Node(DynamicDocument):
    pass


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

def save_to_database(dic, typ):

    """

    :param dic: a dict like {name: value,...}
    :param typ: to insert {type: }
    """
    node = Node()
    for key in dic.keys():
        exec "node.%s = dic[key]" % key
    #node.type = typ
    node.save()

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
    typ = re.search(r'(?<=node/).*?(?=\.txt)', path)
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
    basepath = './node'

    paths = get_dirs(basepath)


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

            for i in xrange(len(fields)):
                fields[i] = standardized(fields[i])

            print "pattern:  "+str(fields) + '\n'+str(len(fields))+'\n\n'

            while line:
                line = fp.readline()
                if line:
                    if typ == 'Gene':
                        line = drop_brackets(line)
                    line = line.replace('\n', '')
                    dic = dataprocess(fields, line)
                    save_to_database(dic, typ)


def main_2():
    basepath = './father'
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
                    child.father = father
                    try:
                        child.save()
                        print 'succeed!  '+ str(dict(child.to_mongo())['father'])
                    except errors.OperationError:
                        pass






if __name__ == '__main__':
    main_2()

