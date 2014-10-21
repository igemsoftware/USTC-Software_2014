__author__ = 'Beibeihome'

from pymongo import *
import CONSTANT
from CONSTANT import db


## 2014/8/22
## This patch is manage to reset database to index-object mode
## After patch ,Version is 1.1.0.0

INIT_COUNTER_NUM_SERVER = 1
INIT_COUNTER_NUM_CLIENT = 0
INIT_LOCATION = 0


def create_noderef_coll():
    # extract together
    cursor = db.node.find(timeout=False)
    log_list = []
    for log in cursor:
        log_list.append(log)
    cursor.close()
    print 'Extract node from database over'

    content_list = []
    for log in log_list:
        content = {'node_id': log['_id'], 'x': INIT_LOCATION, 'y': INIT_LOCATION}
        # In Kegg database, we use NAME_KEGG as NAME in index table
        if log['TYPE'] in ['Enzyme', 'Compound']:
            if 'NAME_KEGG' in log.keys():
                content['nickname'] = log['NAME_KEGG']
            else:
                content['nickname'] = log['NAME']
        else:
            content['nickname'] = log['NAME']
        content_list.append(content)
    ref_log_id_list = db.node_ref.insert(content_list)
    for ref_log_id in ref_log_id_list:
        ref_log = db.node_ref.find_one({'_id': ref_log_id})
        db.node.update({'_id': ref_log['node_id']}, {'$push': {'REF': ref_log_id}})
    print 'Basic index table of node establishing is over '
    db.node_ref.create_index('pid')


def create_linkref_coll():
    # extract together
    cursor = db.link.find(timeout=False)
    log_list = []
    for log in cursor:
        log_list.append(log)
    cursor.close()
    print 'Extract link from database over'

    content_list = []
    for log in log_list:
        content = {'link_id': log['_id'], 'id1': log['NODE1'], 'id2': log['NODE2']}
        content_list.append(content)

    ref_log_id_list = db.link_ref.insert(content_list)

    for ref_log_id in ref_log_id_list:
        ref_log = db.link_ref.find_one({'_id': ref_log_id})
        db.link.update({'_id': ref_log['link_id']}, {'$push': {'REF': ref_log_id}})

    db.link_ref.create_index([('id1', ASCENDING), ('id2', DESCENDING)])
    db.link_ref.create_index('pid')

    print 'Basic index table of link establishing is over'


def renew_nodedb():
    db.node.update({}, {'$unset': {'EDGE': ""}}, multi=True)
    db.node.update({}, {'$set': {'REF_COUNT': INIT_COUNTER_NUM_SERVER}}, multi=True)
    sum_num = db.node.find().count()
    print 'All of ' + str(sum_num) + ' logs has been processed'
    print 'EDGE of node has been deleted'
    print 'Set REF_COUNT attribute on node'


def renew_linkdb():
    db.link.update({}, {'$unset': {'NODE1': "", 'NODE2': ""}}, multi=True)
    db.link.update({}, {'$set': {'REF_COUNT': INIT_COUNTER_NUM_SERVER}}, multi=True)
    sum_num = db.link.find().count()
    print 'All of ' + str(sum_num) + ' logs has been processed'
    print 'NODE_id attribute of link has been deleted'
    print 'Set REF_COUNT attribute on link'


def main():
    create_noderef_coll()
    create_linkref_coll()
    renew_nodedb()
    renew_linkdb()

main()
