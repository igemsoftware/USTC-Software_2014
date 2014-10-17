"""
This module gives several methods that helps users to interact with our database without knowing the components of 
it. These methods simply encapsulate the interaction with the database and will return error reason when you are doing 
something illegal, so you can use these methods to get to our database conveniently and safely. What's more, they are 
concise enough for anyone who wants to implement their own functions to custom their own version.
"""
__author__ = 'feiyicheng'
import json
from bson.objectid import ObjectId
from dict2xml import dict2xml
from projects.models import Project
from func_box import *


def insert(db, coll_name, data):
    """ insert data into db.<coll_name>
    
    data should be a python dict object.coll_name is a string, and db is the object represents the database,
    generated using pymongo. For more information, see <http://api.mongodb.org/python/current/tutorial.html>
    """
    if validate(data):
        obj_id = None
        exec ("obj_id  = db.{0}.insert(data)".format(coll_name))
        if obj_id is None:
            return {'error': 'fail to insert in to database'}
        else:
            return obj_id
    else:
        return {'error': 'data invalid!'}


def add_node(db, data, pid, x=0, y=0):
    """ add_node from data into database

    This method does the following things:
    1.add a record in db.node using the 'data'.
    2.add a reference record of the node into db.node_ref collection under the name of the project that 'pid' represents.


    @param data: dict
    @parem pid: int
    @param db: database object generated using pymongo.For more information, see <http://api.mongodb.org/python/current/tutorial.html>
    @return: a tuple (<node_id>,<noderef_id>) <node_id>,<noderef_id> are all ObjectId
    """
    node_id = insert(db, 'node', data)
    if isinstance(node_id, dict):
        return node_id
    ref_data = {
        'pid': int(pid),
        'x': float(x),
        'y': float(y),
    }
    noderef_id = insert(db, 'node_ref', ref_data)
    if isinstance(noderef_id, dict):
        return noderef_id

    prj = db.project.find_one({'pid': int(pid)})
    if prj is None:
        # prj does not exist
        insert(db, 'project', {'pid': int(pid), 'node': [], 'link': []})
        prj = db.project.find_one({'pid': int(pid)})
    db.project.update({'_id': prj['_id']}, {'$push': {'node': noderef_id}}, True)

    db.node.update({'_id': node_id}, {'$push': {'refs': noderef_id}}, True)
    db.node_ref.update({'_id': noderef_id}, {'$set': {'node_id': node_id}})

    return node_id, noderef_id


def add_link(db, data, pid, id1, id2):
    """ add link from data into database

    This method does the following things:
    1.add a record in db.link using the 'data'.
    2.add a reference record of the node into db.link_ref collection under the name of the project that 'pid' represents.
    The record keeps a reference to id1,id2(they are the primary key of two node_refs)


    @param data: dict
    @para id1,id2: string
    @parem pid: int
    @param db: database object generated using pymongo.For more information, see <http://api.mongodb.org/python/current/tutorial.html>
    @return: a tuple (<link_id>,<linkref_id>) <link_id>,<linkref_id> are all ObjectId
    """
    link_id = insert(db, 'link', data)
    if isinstance(link_id, dict):
        return link_id
    ref_data = {
        'pid': int(pid)
    }
    linkref_id = insert(db, 'link_ref', ref_data)
    if isinstance(linkref_id, dict):
        return linkref_id

    prj = db.project.find_one({'pid': int(pid)})
    if prj is None:
        # prj does not exist
        insert(db, 'project', {'pid': int(pid), 'node': [], 'link': []})
        prj = db.project.find_one({'pid': int(pid)})
    db.project.update({'_id': prj['_id']}, {'$push': {'link': linkref_id}}, True)

    db.link.update({'_id': link_id}, {'$push': {'refs': linkref_id}}, True)
    db.link_ref.update({'_id': linkref_id}, {'$set': {'link_id': link_id,
                                                      'id1': ObjectId(id1),
                                                      'id2': ObjectId(id2), }})
    return link_id, linkref_id


def fork_node(db, node_id, pid, x=0, y=0):
    """ make a reference of the node

    the method will merely add a record in db.node_ref consisting of 
    1. reference to node_id;
    2. pid;
    3. the position of the node in user's screen(the x, y param)

    @param node_id: string
    @param pid: a int object, a string that can be converted to int is alse OK
    @return: a tuple of ObjectId (<node_id>, <noderef_id>), otherwise a dict with error info
    """
    if not isinstance(node_id, str):
        return {'error': 'node_id must be a string'}
    node = db.node.find_one({'_id': ObjectId(node_id)})
    if node is None:
        return {'error': 'node matching the given id not found'}
    noderef_data = {
        'pid': int(pid),
        'x': float(x),
        'y': float(y),
        'node_id': node['_id']
    }
    noderef_id = insert(db, 'node_ref', noderef_data)
    if isinstance(noderef_id, dict):
        return noderef_id

    prj = db.project.find_one({'pid': int(pid)})
    if prj is None:
        # prj does not exist
        insert(db, 'project', {'pid': int(pid), 'node': [], 'link': []})
        prj = db.project.find_one({'pid': int(pid)})
    db.project.update({'_id': prj['_id']}, {'$push': {'node': noderef_id}}, True)

    db.node.update({'_id': node['_id']}, {'$push': {'refs': noderef_id}}, True)

    return node['_id'], noderef_id


def fork_link(db, node_id, pid, id1, id2):
    """ make a reference of the link

    the method will merely add a record in db.link_ref consisting of 
    1. reference to link_id;
    2. pid;
    3. the position of the node in user's screen(the x, y param)

    @param node_id: string
    @param id1, id2: string or ObjectId
    @param pid: a int object, a string that can be converted to int is alse OK
    @return: a tuple of ObjectId (<node_id>, <noderef_id>), otherwise a dict with error info
    """
    #if id1, id2 are ObjectId object, convert to str
    if isinstance(id1, ObjectId):
        id1 = str(id2)
    if isinstance(id2, ObjectId):
        id2 = str(id2)

    # get the link object
    if not isinstance(node_id, str):
        return {'error': 'node_id must be a string'}
    link = db.link.find_one({'_id': ObjectId(node_id)})
    if link is None:
        return {'error': 'link matching the given id not found'}

    # add a ref record to the ref collection
    linkref_data = {
        'pid': int(pid),
        'id1': ObjectId(id1),
        'id2': ObjectId(id2),
        'node_id': link['_id']
    }
    linkref_id = insert(db, 'node_ref', linkref_data)
    if isinstance(linkref_data, dict):
        return linkref_data

    # update references in the project
    prj = db.project.find_one({'pid': int(pid)})
    if prj is None:
        # prj does not exist
        insert(db, 'project', {'pid': int(pid), 'node': [], 'link': []})
        prj = db.project.find_one({'pid': int(pid)})
    db.project.update({'_id': prj['_id']}, {'$push': {'link': linkref_id}}, True)

    # update references in the link record
    db.link.update({'_id': link['_id']}, {'$push': {'refs': linkref_id}}, True)

    return link['_id'], linkref_id


def change_loc(db, noderef_id, x=0, y=0):
    """ merely change th location of the node_ref

    @param noderef_id: str or ObjectId
    @return: ObjectId if everything goes right, otherwise a dict with error info
    """

    # standarlize the type of noderef_id(to string)
    if isinstance(noderef_id, ObjectId):
        noderef_id = str(noderef_id)

    # get the node_ref
    node_ref = db.node_ref.find_one({'_id': ObjectId(noderef_id)})
    if node_ref is None:
        return {'error': 'cannot find the node_ref mathcing that id'}
    # change its location
    db.node_ref.update({'_id': ObjectId(noderef_id)}, {'$set': {'x': float(x), 'y': float(y)}})
    # return
    return ObjectId(noderef_id)


def delete(db, coll_name, ref_id):
    """ delete a ref

    Cause the 'db.node' collection actually does not delete anyone record, the method only delete
    a reference record belonging to the user himself/herself.

    :param coll_name: 'link' or 'node'
    :param ref_id: string or ObjectId
    :return: None if everything goes right, otherwise a dict containing err info
    """
    # verify collname
    if coll_name not in ['node', 'link']:
        return {'error': 'coll_name is invalid!'}

    # standarlize the type of noderef_id(to string)
    if isinstance(ref_id, ObjectId):
        ref_id = str(ref_id)

    # get the reference object
    query = {'_id': ObjectId(ref_id)}
    ref = None
    exec("ref = db.{0}_ref.find_one(query)".format(coll_name))
    if ref is None:
        return {'error': 'cannot find the ref matching that id'}

    # get the original object
    query = {'_id': ref['node_id'] if coll_name == 'node' else ref['link_id']}
    obj = None
    exec("obj = db.{}.find_one(query)".format(coll_name))
    if obj is None:
        return {'error': 'cannot find the node/link matching that id'}

    # remove ref from the original object
    exec("db.%s.update({'_id': obj['_id']}, {'$pull': {'refs': ref['_id']}}, True)" % coll_name)

    # remove the reference object
    exec("db.%s_ref.remove({'_id': ObjectId(ref_id)})" % coll_name)
    # return

    return None










