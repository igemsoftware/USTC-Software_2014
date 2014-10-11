__author__ = 'Beibeihome'
from Modules.kegg_parse import *
from pymongo import *
from bson.objectid import ObjectId
import CONSTANT

db = MongoClient()[CONSTANT.DATABASE]


class count(Document):
    type = StringField()
    value = IntField()


def getID(node_or_link):
    counter = count.objects.filter(type=node_or_link)[0]
    ID = counter['value']
    counter['value'] += 1
    counter.save()
    return ID


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


def reaction_compound_linkset():
    #connect(CONSTANT.DATABASE)
    #faven't been used
    reaction_counter = 0
    found_counter = 0
    missed_counter = 0
    reaction_list = []
    cursor = db['node'].find({'TYPE': 'Reaction'}, timeout=False)
    for reaction in cursor:
        reaction_list.append(reaction)
    cursor.close()
    for reaction in reaction_list:
        reaction_counter += 1
        #if reaction_counter % 100 == 0:
            #print str(reaction_counter) + ' reactions has been analysed,and now ' + reaction['NAME'] + ' is on the process'
        ## reaction is a node whose TYPE is Reaction
        for reactant in reaction['REACTANTS']:
            #reactant is a String Form
            reactant_node = db.node.find_one({'NAME': reactant})
            if not reactant_node:
                #print 'Reaction_Reactants_Connect: ' + reactant + ' in ' + reaction.NAME + ' is not found'
                missed_counter += 1

            else:
                setLink(reactant_node, reaction, 'Compound', 'Reaction')

        for product in reaction['PRODUCTS']:
            #product is a String
            product_node = db.node.find_one({'NAME': product})
            if not product_node:
                #print 'Reaction_Product_Connect: ' + product + ' in ' + reaction.NAME + ' is not found'
                missed_counter += 1
            else:
                setLink(reaction, product_node, 'Reaction', 'Compound')

        if 'ENZYME' in reaction and reaction['ENZYME']:
            #print 'Has Enzyme'
            for enzyme in reaction['ENZYME']:
                enzyme_node = db.node.find_one({'NAME': enzyme})
                if not enzyme_node:
                    #print 'Reaction_Enzyme_Connect: ' + enzyme + ' in ' + reaction.NAME + ' is not found'
                    missed_counter += 1
                else:
                    setLink(enzyme_node, reaction, 'Enzyme', 'Reaction')

reaction_compound_linkset()