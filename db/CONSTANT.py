__author__ = 'Beibeihome'

from datetime import *
from pymongo.mongo_replica_set_client import MongoReplicaSetClient

#DATABASE = 'igemdata_new'
DATABASE = 'dump_new'

client = MongoReplicaSetClient('mongodb://product:bXYtvBHrSdbuTMETSVO4VTWGl0oeddBHp3hPNsUbEZOEpRFLcqgaYAjHRirnSI@us-ce-0:27017,cn-ah-0:27017,cn-bj-0:27017', replicaSet='replset')
db = client[DATABASE]
LOG_PATH = './log/log' + str(datetime.now().month) + '_' + str(datetime.now().day) + '.txt'
