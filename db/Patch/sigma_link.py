__author__ = 'beibeihome'

from pymongo import *
import bson
from CONSTANT import db

def setLink(doc1, doc2, type1, type2):
	if not type1:
		type1 = doc1['TYPE']
	if not type2:
		type2 = doc2['TYPE']
	link_instance = {}
	#link_instance.ID = getID('link')
	link_instance['NODE1'] = bson.ObjectId(doc1['_id'])
	link_instance['NODE2'] = bson.ObjectId(doc2['_id'])
	link_instance['TYPE1'] = type1
	link_instance['TYPE2'] = type2
	link_id = db.link.insert(link_instance)
	del link_instance
	#print link_id
	db.node.update({'_id': doc1['_id']}, {'$push': {'EDGE': link_id}})
	db.node.update({'_id': doc2['_id']}, {'$push': {'EDGE': link_id}})
	return link_id


fp = open('./Patch/Protein_TU.txt', 'r')
text = fp.read()
line_list = text.split('\n')
field_list = line_list[0].split('\t')
for line in line_list[1:]:
	attri_list = line.split('\t')
	attri_list[1] = attri_list[1].split('[')[0]
	print attri_list
	node1 = db.node.find_one({'NAME': attri_list[0], 'TYPE': 'Protein'})
	node2 = db.node.find_one({'NAME': attri_list[1], 'TYPE': 'TU'})
	if node1 and node2:
		link_id = setLink(node1, node2, 'Protein', 'TU')
		# insert dictionary create
		dict = {}
		for i in xrange(len(field_list)):
			dict[field_list[i]] = attri_list[i]
		db.link.update({'_id': link_id}, {'$set': dict})
	else:
		print 'not found'
