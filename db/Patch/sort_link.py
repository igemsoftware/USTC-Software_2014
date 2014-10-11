__author__ = 'Beibeihome'

from pymongo import *
import CONSTANT

node_link_type = {'Reaction': 'React', 'Compound': 'React', 'Enzyme': 'Catalyze', 'sRNA': 'Tiaokong',
                  'Gene': 'Produce', 'TF': 'Tiaokong', 'TU': 'Contain', 'Operon': 'Contain', 'Protein': 'Tiaokong'}
db = MongoClient()[CONSTANT.DATABASE]

for link in db.link.find():
    db.link.update({'_id': link['_id']}, {'$set': {'TYPE': node_link_type[link['TYPE1']]}})
    link['TYPE'] = node_link_type[link['TYPE1']]
    #print 'link[\'TYPE1\']: ' + link['TYPE1']
    #print 'node_link_type[link[\'TYPE1\']]: ' + node_link_type[link['TYPE1']]
    if link['TYPE'] == 'Tiaokong':
        db.link.update({'_id': link['_id']}, {'$set': {'TYPE': link['Function']}})

print 'LINK ADDING SUCCESS'