__author__ = 'Beibeihome'

from pymongo import *
import os
import CONSTANT

db = MongoClient()['igemdata']
data_path = './'

for file in os.listdir(data_path):
    filepath = os.path.join(data_path, file)
    gene_node = db.node.find({'NAME': file.split('.')[0]})
    if db.link