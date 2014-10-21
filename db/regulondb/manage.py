__author__ = 'feiyicheng'


from regulondb.toolbox import *
from Modules import convert_to_mongodb
from regulondb import generate_product_collection
from regulondb import add_ref, add_refs_father, import_data_link, import_data_node, initiate
import pymongo
from CONSTANT import db


print 'initiate database'
initiate.main()

print 'importing node....'
import_data_node.main()

print 'importing link....'
import_data_link.main()

#print 'adding father-child refs....'
#add_refs_father.main()

print 'adding refs....'
add_ref.main()

print 'generating collection <product>'
generate_product_collection.main()

