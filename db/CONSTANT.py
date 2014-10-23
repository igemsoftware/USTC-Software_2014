__author__ = 'Beibeihome'

from datetime import *
from pymongo.mongo_replica_set_client import MongoReplicaSetClient
from mongoengine import connect
#DATABASE = 'igemdata_new'
DATABASE = 'dump_new'

client = MongoReplicaSetClient('mongodb://import:Dmd2WkjlpmBfInLTY20swgsGO2CQF0bHXn3mWS0niLsJNq0ZqEiiSzNZv0YRUk@us-ce-0:27017,cn-ah-0:27017,cn-bj-0:27017/dump_new', replicaSet='replset')
db = client[DATABASE]
connect(DATABASE, host='mongodb://import:Dmd2WkjlpmBfInLTY20swgsGO2CQF0bHXn3mWS0niLsJNq0ZqEiiSzNZv0YRUk@us-ce-0:27017,cn-ah-0:27017,cn-bj-0:27017/dump_new', replicaSet='replset')
LOG_PATH = './log/log' + str(datetime.now().month) + '_' + str(datetime.now().day) + '.txt'
