__author__ = 'Beibeihome'

from pymongo import *
import bson
import json
'''
This code page is aim to test expandiable-level of node in database
For that, this also contains some database basing control function
'''

db = MongoClient()['dump_new']


# What's down here is function about control database
def get(finished_list):
    node = db.node.find_one({'_id': {'$nin': finished_list}})
    if node in None:
        return False
    return node['_id']


def look_around(_id):
    obj_id = _id
    node_log = db.node.find_one({'_id': bson.ObjectId(obj_id)})
    if node_log == None:
        return {}
    link_list1 = db.link_ref.find({'id1': bson.ObjectId(obj_id)})
    link_list2 = db.link_ref.find({'id2': bson.ObjectId(obj_id)})
    id_list = []

    for link in link_list1:
        if obj_id in id_list:
            continue
        id_list.append(link['id2'])

    for link in link_list2:
        if obj_id in id_list:
            continue
        id_list.append(link['id1'])

    return id_list


