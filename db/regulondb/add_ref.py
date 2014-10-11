__author__ = 'feiyicheng'

from toolbox import *
import pymongo
import CONSTANT


def main():
    for edge in db.link.find():
        type1 = edge['TYPE1']
        type2 = edge['TYPE2']
        #print 'type1: ' + type1
        #print 'type2: ' + type2
        try:
            name1 = edge[type1]
            name2 = edge[type2]
            #print 'name1: ' + name1
            #print 'name2: ' + name2
        except KeyError:
            continue

        node1 = db.node.find_one({'TYPE': type1, 'NAME': name1})
        node2 = db.node.find_one({'TYPE': type2, 'NAME': name2})
        if node1 and node2:
            #add node id to edge
            edge['NODE1'] = node1['_id']
            edge['NODE2'] = node2['_id']
            db.link.update({'_id': edge['_id']}, {"$set": {"NODE1": node1['_id']}})
            db.link.update({'_id': edge['_id']}, {"$set": {"NODE2": node2['_id']}})

            #add edge to nodes
            db.node.update({'_id': node1['_id']}, {"$push": {"EDGE": edge['_id']}})
            db.node.update({'_id': node2['_id']}, {"$push": {"EDGE": edge['_id']}})
            print 'node_ref added successfully || edge+_id:' + str(edge['ID'])

        else:
            db.link.remove({'_id': edge['_id']})
            print "link :can't find"


