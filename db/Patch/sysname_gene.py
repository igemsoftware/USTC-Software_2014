__author__ = 'Beibeihome'

from pymongo import *
import CONSTANT
from CONSTANT import db


def base_name_to_uni(database_name):
    uni_name = database_name.replace('-', '').split('_')[0]
    return uni_name


for gene in db.node.find({'TYPE': 'Gene'}):
    uni_name = base_name_to_uni(gene['NAME'])
    uni_log = db.uniprot.find_one({'gene_name': uni_name})
    if uni_log is not None:
        sysname_list = uni_log['gene_name']
        sysname_list.remove(uni_name)
        db.node.update({'_id': gene['_id']}, {'$set': {'SYSNAME': sysname_list}})
print 'SYSNAME ADDING SUCCESS'