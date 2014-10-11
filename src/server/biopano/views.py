__author__ = 'Beibeihome'

from pymongo import *
from django.shortcuts import HttpResponse
from django.http import QueryDict
import bson
import json
import urllib


db = MongoClient()['igemdata_new']


def look_around(request, **kwargs):
    if request.method == 'GET':
        obj_id = kwargs['obj_id']
        node_log = db.node.find_one({'_id': bson.ObjectId(obj_id)})
        if node_log == None:
            return HttpResponse("{'status':'error', 'reason':'no record match that id'}")
        link_list1 = db.link_ref.find({'id1': bson.ObjectId(obj_id)})
        link_list2 = db.link_ref.find({'id2': bson.ObjectId(obj_id)})
        dict_list = []

        link_exist_list = []
        for link in link_list1:
            dict_one = {}
            dict_one['link_id'] = str(link['link_id'])
            if link['link_id'] in link_exist_list:
                del dict_one
                continue
            object_link = db.link.find_one({'_id': link['link_id']})
            dict_one['link_type'] = object_link['TYPE']
            link_exist_list.append(link['link_id'])
            dict_one['node_id'] = str(link['id2'])
            object_node = db.node.find_one({'_id': bson.ObjectId(link['id2'])})
            dict_one['NAME'] = object_node['NAME']
            dict_one['TYPE'] = object_node['TYPE']
            dict_one['DIRECT'] = 1
            dict_list.append(dict_one)
            del dict_one

        link_exist_list = []
        for link in link_list2:
            dict_one = {}
            dict_one['link_id'] = str(link['link_id'])
            if link['link_id'] in link_exist_list:
                del dict_one
                continue
            object_link = db.link.find_one({'_id': link['link_id']})
            dict_one['link_type'] = object_link['TYPE']
            link_exist_list.append(link['link_id'])
            dict_one['node_id'] = str(link['id1'])
            object_node = db.node.find_one({'_id': bson.ObjectId(link['id1'])})
            dict_one['NAME'] = object_node['NAME']
            dict_one['TYPE'] = object_node['TYPE']
            dict_one['DIRECT'] = 0
            dict_list.append(dict_one)
            del dict_one

        result_text = json.dumps(dict_list)
        return HttpResponse(result_text)

    elif request.method == 'POST':
        return HttpResponse("{'status':'error', 'reason':'no POST method setting'}")


def request_show(request):
    body = str(request.body)
    if request.method == 'PATCH':
        paras = QueryDict(body)
        result = 'body:\t ' + body + '\nparas:\n' + str(paras) + '\nid1:\t' + str(paras.get('id1'))

    return HttpResponse(result)
