__author__ = 'Beibeihome'

from pymongo import *
import CONSTANT
from bson import ObjectId

db = MongoClient()[CONSTANT.DATABASE]


def setLink(doc1, doc2, type1, type2):
    if not type1:
        type1 = doc1['TYPE']
    if not type2:
        type2 = doc2['TYPE']
    link_instance = {}
    #link_instance.ID = getID('link')
    link_instance['NODE1'] = ObjectId(doc1['_id'])
    link_instance['NODE2'] = ObjectId(doc2['_id'])
    link_instance['TYPE1'] = type1
    link_instance['TYPE2'] = type2
    link_id = db.link.insert(link_instance)
    #print link_id
    db.node.update({'_id': doc1['_id']}, {'$push': {'EDGE': link_id}})
    db.node.update({'_id': doc2['_id']}, {'$push': {'EDGE': link_id}})


def main():
    dict = {}
    for RNA in db.product.find({'TYPE': {'$ne': 'Protein'}}):
        dict['NAME'] = RNA['NAME']
        if dict['NAME'] == '':
            continue
        dict['TYPE'] = RNA['TYPE']
        # NAME standardize
        if dict['TYPE'] == 'tRNA':
            NAME = dict['NAME'].split('>')[1]
            NAME = NAME.split('<')[0]
            dict['NAME'] = NAME
        # if don't do this, tRNA will throw Duplicate Key Error
        if '_id' in dict:
            dict.pop('_id')
            print 'this one have _id'
        print dict
        gene = db.node.find_one({'TYPE': 'Gene', 'NAME': RNA['Gene']})
        if gene is None:
            continue
        node_sRNA = db.node.find_one({'TYPE': 'sRNA', 'NAME': dict['NAME']})
        if dict['TYPE'] == 'sRNA' and node_sRNA is not None:
            print 'This '
            setLink(gene, node_sRNA, 'Gene', 'sRNA')
        else:
            RNA_id = db.node.insert(dict)
            RNA_node = db.node.find_one({'_id': RNA_id})
            setLink(gene, RNA_node, 'Gene', dict['TYPE'])

main()





