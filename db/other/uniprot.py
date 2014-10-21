__author__ = 'Beibeihome'

from pymongo import *
import os
from xml.etree import ElementTree as ET
import CONSTANT
from bson import ObjectId
from CONSTANT import db

data_path = './other/data/'
#data_path = './data/'
log_path = './log/uniprot_no_protein_list.txt'


def convertName(database_name):
    line = database_name.replace('-', '')
    line = line.split('_')[0]
    return line


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


count = 0
for file in os.listdir(data_path):
    print 'Parsing ' + file
    filepath = os.path.join(data_path, file)
    if not file.endswith('xml'):
        print 'continue'
        continue
    # resolve same name conflict
    gene_name = file.split('split')[0].split('.')[0]
    if db.node.find_one({'NAME': gene_name, 'TYPE': 'Gene'}) is None:
        continue
    if 'split' in file:
        uniprot_name = file.split('split')[1].split('.')[0]
    else:
        uniprot_name = convertName(gene_name)
    protein_dict = {}
    protein_dict['NAME'] = db.uniprot.find_one({'gene_name': uniprot_name})['protein_name']

    protein_dict['TYPE'] = 'Protein'
    gene = ET.parse(filepath)
    entry = gene.getroot().find('entry')

    # recommend name saved
    recommend_name = entry.find('protein').find('recommendedName')
    if recommend_name is not None:
        protein_dict['recommend_name'] = recommend_name.find('fullName').text

    # alternative name saved
    alternative_name = entry.find('protein').find('alternativeName')
    if alternative_name is not None:
        protein_dict['alternativeName'] = alternative_name.find('fullName').text

    # organism saved
    organism = entry.find('organism').find('name').text
    protein_dict['organism'] = organism
    taxon_list = []
    for taxon in entry.find('organism').find('lineage').getchildren():
        taxon_list.append(taxon.text)
    protein_dict['taxon'] = taxon_list

    # synonym saved
    gene_dict = {}
    for name in entry.find('gene').getchildren():
        if name.attrib == 'synonym':
            gene_dict['synonym'] = name.text
        #elif name.attrib == 'primary':
        #    protein_dict['NAME'] = name.text

    protein_id = db.node.insert(protein_dict)
    protein_node = db.node.find_one({'_id': protein_id})
    gene_node = db.node.find_one({'NAME': gene_name, 'TYPE': 'Gene'})
    setLink(gene_node, protein_node, 'Gene', 'Protein')
    count += 1

print str(count) + ' protein saved'




