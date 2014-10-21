__author__ = 'Beibeihome'

from pymongo import *
from datetime import datetime
import CONSTANT
from CONSTANT import db


user_template = {'_cls': 'User', 'username': 'USTC_Software2014', 'is_staff': False, 'is_active': True,
                 'is_superuser': False, 'last_login': datetime.now(), 'date_joined': datetime.now(),
                 'user_permissions': []}

project_file_template = {'author': '', 'collaborators': [], 'name': '', 'description': '', 'species': 'E.coli K12',
                         'is_active': True}

project_template = {'node': [], 'link': [], 'pid': None, 'name': ''}

user_id = db.user.insert(user_template)

project_file_template['author'] = user_id
project_file_template['name'] = 'KEGG'
kegg_id = db.project_file.insert(project_file_template)
project_file_template['name'] = 'RegulonDB'
regulondb_id = db.project_file.insert(project_file_template)
project_file_template['name'] = 'Uniprot'
uniprot_id = db.project_file.insert(project_file_template)

project_template['pid'] = kegg_id
project_template['name'] = 'KEGG'
db.project.insert(project_template)

project_template['pid'] = regulondb_id
project_template['name'] = 'KEGG'
db.project.insert(project_template)

project_template['pid'] = uniprot_id
project_template['name'] = 'Uniprot'
db.project.insert(project_template)

# scan database
KEGG_TYPE = ['Compound', 'Reaction', 'Enzyme']
for node in db.node.find():
    if node['TYPE'] in KEGG_TYPE:
        db.project.update({'name': 'KEGG'}, {'$push': node['REF'][0]})
        db.node_ref.update({'_id': node['REF'][0]}, {'pid': kegg_id})
    elif node['TYPE'] == 'Protein':
        db.project.update({'name': 'Uniprot'}, {'$push': node['REF'][0]})
        db.node_ref.update({'_id': node['REF'][0]}, {'pid': uniprot_id})
    else:
        db.project.update({'name': 'RegulonDB'}, {'$push': node['REF'][0]})
        db.node_ref.update({'_id': node['REF'][0]}, {'pid': regulondb_id})






