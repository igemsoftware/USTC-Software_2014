__author__ = 'feiyicheng'

import json
from django.shortcuts import HttpResponse
from pymongo import  MongoClient
from bson.objectid import ObjectId
import bson
from dict2xml import dict2xml
from func_box import *
from decorators import project_verified, logged_in, project_verified_exclude_get, logged_in_exclude_get
from projects.models import ProjectFile
from IGEMServer.settings import db_write, db_read
from django.http import QueryDict



@logged_in
@project_verified
def add_node(request):
    """ This api will store data of one node from logged-in user to our database

    node data should be passed in with the POST method with the following format:

    "info":<query>  ,query is in JSON format

    @param request: django request object
    @return: success prompt or error information
    """
    if request.method == "POST":
        '''
            add a node id collection <node>
            request.POST is all information of the node
        '''
        if validate_node(json.loads(request.POST['info'])):
            # all the information is valid(including the group)
            node_id = db_write.node.insert(json.loads(request.POST['info']))
            noderef_id = db_write.node_ref.insert(
                {'pid': ObjectId(request.POST['pid']) if 'pid' in request.POST.keys() else 0,
                 'x': float(request.POST['x']) if 'x' in request.POST.keys() else '0',
                 'y': float(request.POST['y']) if 'y' in request.POST.keys() else '0',
                }
            )

            prj_id = db_read.project.find_one({'pid': ObjectId(request.POST['pid'])})
            if prj_id is None:
                prj_id = db_write.project.insert({'pid': ObjectId(request.POST['pid']), 'node': [], 'link': []})
                prj_id = db_read.project.find_one({'_id': prj_id})
            else:
                pass
            db_write.project.update({'_id': prj_id['_id']}, {'$push': {'node': noderef_id}}, True)

            # fail to insert into database
            if not node_id or not noderef_id:
                return HttpResponse("{'status':'error', 'reason':'insert failed'}")

            # add refs between two records
            db_write.node.update({'_id': node_id}, {'$push': {'REF': noderef_id}}, True)
            db_write.node_ref.update({'_id': noderef_id}, {'$set': {'node_id': node_id}})

            # return the _id of this user's own record of this node
            data = {
                'status': 'success',
                'ref_id': str(noderef_id),
                'id': str(node_id),
            }
            return HttpResponse(json.dumps(data))

        else:
            # node info is incorrect
            return HttpResponse('{"status":"error", "reason":"node info invalid"}')

    else:
        # not using method POST
        return HttpResponse('{"status":"error", "reason":"pls use method POST"}')


@logged_in_exclude_get
@project_verified_exclude_get
def get_del_addref_node(request, **kwargs):
    """ A RESTful api that user can get/delete and make a copy using different method

    Following are the mapping between method and operation:
        1. GET: return all infomation of the node asked.
        2. DELETE: delete the specific node if the logged-in user has access to do so.
        3. PUT: make a copy(actually a ref) that belongs to the project which the user is working on.
        4. PATCH: merely modify the x, y coordinates of specific node

    @param kwargs: kwarg['id'] is the object_id or ref_id
    @param request: django request object
    @type request: django.http.request
    @return: success prompt or error information
    """
    if request.method == 'DELETE':
        '''
            DELETE A REF IN COLLECTION<node_ref>
        '''
        paras = request.POST
        project = db_read.project.find_one({'pid': ObjectId(paras['pid'])})
        noderef = db_read.node_ref.find_one({'_id': ObjectId(kwargs['ID'])})

        # not found
        if noderef is None:
            return HttpResponse("{'status':'error', 'reason':'no record match that id'}")
        if project is None:
            return HttpResponse("{'status':'error', 'reason':'project not found'}")

        # remove ref in specific node record
        db_write.node.update({'_id': noderef['node_id']}, {'$pull': {"REF": noderef['_id']}})

        # remove node_ref record
        db_write.node_ref.remove({'_id': noderef['_id']})
        db_write.project.update({'_id': project['_id']}, {'$pull': {"node": noderef['_id']}})

        return HttpResponse("{'status': 'success'}")

    elif request.method == 'PUT':
        '''
            add a ref record in collection <node_ref>
        '''
        paras = request.POST
        try:
            node = db_read.node.find_one({'_id': ObjectId(kwargs['ID'])})
        except KeyError:
            return HttpResponse("{'status':'error', 'reason':'key <_id> does not exist'}")

        # not found
        if node is None:
            return HttpResponse("{'status':'error', 'reason':'object not found'}")

        # node exists
        noderef_id = db_write.node_ref.insert({'pid': ObjectId(paras['pid']) if 'pid' in paras.keys() else 0,
                                         'x': paras['x'] if 'x' in paras.keys() else '0',
                                         'y': paras['y'] if 'y' in paras.keys() else '0',
                                         'node_id': node['_id']}
        )

        if noderef_id:
            prj_id = db_read.project.find_one({'pid': ObjectId(request.POST['pid'])})
            if prj_id is None:
                prj_id = db_write.project.insert({
                    'pid': ObjectId(request.POST['pid']),
                    'node': [],
                    'link': [],
                }
                )
                prj_id = db_read.project.find_one({'_id': prj_id})
            else:
                pass
            db_write.project.update({'_id': prj_id['_id']}, {'$push': {'node': noderef_id}}, True)

            data = {'status': 'success', 'ref_id': str(noderef_id)}
            return HttpResponse(json.dumps(data))
        else:
            return HttpResponse("{'status':'error', 'reason':'fail to insert data into database'}")

    elif request.method == 'GET':
        '''
        get the detail info of a record
        :param kwargs: kwargs['_id'] is the object id in collection node
        '''
        BANNED_ATTRI = {'_id': 0, 'REF': 0, 'REF_COUNT': 0, 'ID': 0, 'FATHER': 0, 'CHILD': 0}
        try:
            node = db_read.node.find_one({'_id': ObjectId(kwargs['ID'])}, BANNED_ATTRI)
        except KeyError:
            return HttpResponse("{'status':'error', 'reason':'key <_id> does not exist'}")

        if node is None:
            # not found
            return HttpResponse("{'status':'error', 'reason':'object not found'}")

        else:
            # the node exists
            node_dic = node
            for key in node_dic.keys():
                if isinstance(node_dic[key], bson.objectid.ObjectId):
                    node_dic[key] = str(node_dic[key])
                if (isinstance(node_dic[key], list) and len(node_dic[key]) > 0 and
                        isinstance(node_dic[key][0], ObjectId)):
                    newrefs = []
                    for refid in node_dic[key]:
                        newrefs.append(str(refid))
                    node_dic[key] = newrefs

            return HttpResponse(json.dumps(node_dic))

    elif request.method == 'PATCH':
        '''
        update merely the position(x,y) of the node
        :param request.PATCH: a dict with keys(token, username, info), info is also a dict with keys(x, y, ref_id)
        :return data: {'status': 'success'} if everything goes right
        '''
        paras = request.POST
        # try:
        x = paras['x']
        y = paras['y']
        old_ref_id = kwargs['ID']
        #except KeyError:
        #    return HttpResponse("{'status': 'error','reason':'your info should include keys: x, y, ref_id'}")

        # x,y should be able to convert to a float number
        try:
            fx = float(x)
            fy = float(y)
        except ValueError:
            return HttpResponse("{'status': 'error','reason':'the x, y value should be float'}")

        node = db_read.node_ref.find_one({'_id': ObjectId(old_ref_id)})
        if not node:
            return HttpResponse("{'status': 'error','reason':'unable to find the record matching ref_id given'}")
        else:
            db_write.node_ref.update({'_id': ObjectId(old_ref_id)}, {'$set': {'x': x, 'y': y}})
            return HttpResponse("{'status': 'success}")

    else:
        # method incorrect
        return HttpResponse("{'status': 'error','reason':'pls use method DELETE/PUT/GET/PATCH '}")


def search_json_node(request):
    """ an api used for complex searching

    User passes in a json query using POST method, and this method will return the
    results of this single searching.

    User can use the "$limit" "$or" "$and" paras to apply a complex searching.
    all paras can be seen in U{http://docs.mongodb.org/manual/}

    @param request: django request object
    @return: the results of the query or error information
    """
    if request.method == 'POST':
        ''' POST: {
            'spec': <json query>,
            'fields': <filter in json format>,
            'skip': <INTEGER>,
            'limit': <the max amount to return(INTEGER)>
        }
        '''

        # try if query conform to JSON format
        try:
            queryinstance = json.loads(request.POST['spec'])
        except ValueError:
            return HttpResponse("{'status':'error', 'reason':'query not conform to JSON format'}")

        try:
            filterinstance = json.loads(request.POST['fields'])
        except KeyError:
            # set a default value
            filterinstance = {'_id': 1, 'NAME': 1, 'TYPE': 1}
        except ValueError:
            return HttpResponse("{'status':'error', 'reason':'filter not conform to JSON format'}")

        try:
            limit = int(request.POST['limit'])
            skip = int(request.POST['skip'])
        except KeyError:
            # set a default value
            limit = 20
            skip = 0
        except ValueError:
            return HttpResponse("{'status':'error', 'reason':'limit/skip must be a integer'}")

        # handle _id (string-->ObjectId)

        for key in queryinstance.keys():
            if '_id' == key:
                queryinstance[key] = ObjectId(queryinstance[key])
                continue
            if isinstance(queryinstance[key], list):
                new = []
                for item in queryinstance[key]:
                    if '_id' in item.keys():
                        item['_id'] = ObjectId(item['_id'])
                    new.append(item)
                queryinstance[key] = new

        # vague search
        # for key in queryinstance.keys():
        # if key == 'NAME' or key == "TYPE":
        # queryinstance[key] = {"$regex": queryinstance[key]}
        results = db_read.node.find(queryinstance, filterinstance).limit(limit)

        if 'format' in request.POST.keys():
            # noinspection PyDictCreation
            if request.POST['format'] == 'xml':
                # Pack data into xml format
                lists = []
                for item in results:
                    newitem = {}
                    for key in item.keys():
                        newitem[key] = item[key]
                    lists.append(newitem)
                inss = {}
                inss['result'] = lists
                final = {}
                final['results'] = inss
                data = dict2xml(final)
            else:
                data = None
        else:
            results_data = []
            for result in results:
                for key in result.keys():
                    if isinstance(result[key], bson.objectid.ObjectId):
                        result[key] = str(result[key])
                    if isinstance(result[key], list) and len(result[key]) > 0 and isinstance(result[key][0], ObjectId):
                        newrefs = []
                        for refid in result[key]:
                            newrefs.append(str(refid))
                        result[key] = newrefs
                results_data.append(result)

            data = json.dumps({'result': results_data})

        return HttpResponse(data)

    else:
        # method is not POST
        return HttpResponse("{'status':'error', 'reason':'pls use POST method'}")


@logged_in
@project_verified
def add_link(request):
    """ This api will store data of one link from logged-in user to our database

    node data should be passed in with the POST method with the following format:

    "info":<query>  ,query is in JSON format

    @param request: django request object
    @return: success prompt or error information
    """
    if request.method == "POST":
        # request.POST is all information of the link
        if validate_link(json.loads(request.POST['info'])):
            # all the information is valid(including the group)
            link_id = db_write.link.insert(json.loads(request.POST['info']))
            linkref_id = db_write.link_ref.insert(
                {
                    'pid': ObjectId(request.POST['pid']) if 'pid' in request.POST.keys() else 0,
                }
            )

            # fail to insert into database
            if not link_id or not linkref_id:
                return HttpResponse("{'status':'error', 'reason':'insert failed'}")

            # add refs between two records
            db_write.link.update({'_id': link_id}, {'$push': {'REF': linkref_id}}, True)
            db_write.link_ref.update({'_id': linkref_id}, {'$set': {'link_id': link_id,
                                                              'id1': ObjectId(request.POST['id1']),
                                                              'id2': ObjectId(request.POST['id2'])}})

            prj_id = db_read.project.find_one({'pid': ObjectId(request.POST['pid'])})
            if prj_id is None:
                prj_id = db_write.project.insert({'pid': ObjectId(request.POST['pid']), 'node': [], 'link': []})
                prj_id = db_read.project.find_one({'_id': prj_id})
            else:
                pass
            db_write.project.update({'_id': prj_id['_id']}, {'$push': {'link': linkref_id}}, True)

            # return the _id of this user's own record of this link
            data = {
                'status': 'success',
                'ref_id': str(linkref_id),
                'id': str(link_id),
            }
            return HttpResponse(json.dumps(data))

        else:
            # link info is incorrect
            return HttpResponse('{"status":"error", "reason":"link info invalid"}')

    else:
        # method is not POST
        return HttpResponse('{"status":"error", "reason":"pls use POST method"}')


@logged_in_exclude_get
@project_verified_exclude_get
def get_del_addref_link(request, **kwargs):
    """ A RESTful api that user can get/delete and make a copy using different method

    Following are the mapping between method and operation:
        1. GET: return all infomation of the link asked.
        2. DELETE: delete the specific node if the logged-in user has access to do so.
        3. PUT: make a copy(actually a ref) that belongs to the project which the user is working on.
        4. PATCH: merely modify the x, y coordinates of specific node

    @param kwargs: kwarg['id'] is the object_id or ref_id
    @param request: django request object
    @type request: django.http.request
    @return: success prompt or error information
    """
    if request.method == 'DELETE':
        '''
            DELETE A REF IN COLLECTION<link_ref>
        '''
        paras = request.POST
        project = db_read.project.find_one({'pid': ObjectId(paras['pid'])})
        linkref = db_read.link_ref.find_one({'_id': ObjectId(kwargs['ID'])})

        # not found
        if linkref is None:
            return HttpResponse("{'status':'error', 'reason':'no record match that id'}")
        if project is None:
            return HttpResponse("{'status':'error', 'reason':'project not found'}")

        # remove ref in specific node record
        db_write.link.update({'_id': linkref['link_id']}, {'$pull': {"REF": linkref['_id']}})

        # remove node_ref record
        db_write.link_ref.remove({'_id': linkref['_id']})
        db_write.project.update({'_id': project['_id']}, {'$pull': {"link": linkref['_id']}})

        return HttpResponse("{'status': 'success'}")

    elif request.method == 'PUT':
        '''
            add a ref record in collection <node_ref>
        '''
        paras = request.POST
        try:
            link = db_read.link.find_one({'_id': ObjectId(kwargs['ID'])})
        except KeyError:
            return HttpResponse("{'status':'error', 'reason':'key <_id> does not exist'}")

        # not found
        if link is None:
            return HttpResponse("{'status':'error', 'reason':'object not found'}")

        # link exists
        linkref_id = db_write.link_ref.insert(
            {
                'pid': ObjectId(paras['pid']) if 'pid' in paras.keys() else 0,
                'link_id': ObjectId(kwargs['ID']),
                'id1': ObjectId(paras['id1']),
                'id2': ObjectId(paras['id2'])
            }
        )
        if linkref_id:
            prj_id = db_read.project.find_one({'pid': ObjectId(request.POST['pid'])})
            if prj_id is None:
                prj_id = db_write.project.insert({'pid': ObjectId(request.POST['pid']), 'node': [], 'link': []})
                prj_id = db_read.project.find_one({'_id': prj_id})
            else:
                pass
            db_write.project.update({'_id': prj_id['_id']}, {'$push': {'link': linkref_id}}, True)

            data = {'status': 'success', 'ref_id': str(linkref_id)}
            return HttpResponse(json.dumps(data))
        else:
            return HttpResponse("{'status':'error', 'reason':'insert failed'}")

    elif request.method == 'GET':
        '''
        get the detail info of a record
        '''
        BANNED_ATTRI = {'_id': 0, 'REF': 0, 'REF_COUNT': 0, 'ID': 0}
        try:
            link = db_read.link.find_one({'_id': ObjectId(kwargs['ID'])}, BANNED_ATTRI)
        except KeyError:
            return HttpResponse("{'status':'error', 'reason':'key <_id> does not exist'}")

        if link is None:
            # not found
            return HttpResponse("{'status':'error', 'reason':'object not found'}")

        else:
            # the node exists
            link_dic = link
            for key in link_dic.keys():
                if isinstance(link_dic[key], bson.objectid.ObjectId):
                    link_dic[key] = str(link_dic[key])
                if (isinstance(link_dic[key], list) and len(link_dic[key]) > 0 and
                        isinstance(link_dic[key][0], ObjectId)):
                    newrefs = []
                    for refid in link_dic[key]:
                        newrefs.append(str(refid))
                    link_dic[key] = newrefs

            return HttpResponse(json.dumps(link_dic))

    else:
        # method incorrect
        return HttpResponse("{'status': 'error','reason':'pls use method DELETE/PUT '}")


# @login_required
def search_json_link(request):
    """ an api used for complex searching

    User passes in a json query using POST method, and this method will return the
    results of this single searching.

    User can use the "$limit" "$or" "$and" paras to apply a complex searching.
    all paras can be seen in U{http://docs.mongodb.org/manual/}

    @param request: django request object
    @return: the results of the query or error information
    """
    if request.method == 'POST':
        ''' POST: {
            'spec': <json query>,
            'fields': <filter in json format>,
            'skip': <INTEGER>,
            'limit': <the max amount to return(INTEGER)>
        }
        '''

        # try if query conform to JSON format
        try:
            queryinstance = json.loads(request.POST['spec'])
        except ValueError:
            return HttpResponse("{'status':'error', 'reason':'query not conform to JSON format'}")

        try:
            filterinstance = json.loads(request.POST['fields'])
        except KeyError:
            # set a default value
            filterinstance = {'TYPE1': 1, 'TYPE2': 1, '_id': 1}
        except ValueError:
            return HttpResponse("{'status':'error', 'reason':'filter not conform to JSON format'}")

        try:
            limit = int(request.POST['limit'])
            skip = int(request.POST['skip'])
        except KeyError:
            # set a default value
            limit = 20
            skip = 0
        except ValueError:
            return HttpResponse("{'status':'error', 'reason':'limit must be a integer'}")

        # handle _id (string-->ObjectId)

        for key in queryinstance.keys():
            if '_id' == key:
                queryinstance[key] = ObjectId(queryinstance[key])
                continue
            if isinstance(queryinstance[key], list):
                new = []
                for item in queryinstance[key]:
                    if '_id' in item.keys():
                        item['_id'] = ObjectId(item['_id'])
                    new.append(item)
                queryinstance[key] = new
        results = db_read.link.find(queryinstance, filterinstance).limit(limit)

        if 'format' in request.POST.keys():
            if request.POST['format'] == 'xml':
                # Pack data into xml format
                lists = []
                for item in results:
                    newitem = {}
                    for key in item.keys():
                        newitem[key] = item[key]
                    lists.append(newitem)
                inss = {}
                inss['result'] = lists
                final = {}
                final['results'] = inss
                data = dict2xml(final)
            else:
                data = None
        else:
            results_data = []
            for result in results:
                for key in result.keys():
                    if isinstance(result[key], bson.objectid.ObjectId):
                        result[key] = str(result[key])
                    if isinstance(result[key], list) and len(result[key]) > 0 and isinstance(result[key][0], ObjectId):
                        newrefs = []
                        for refid in result[key]:
                            newrefs.append(str(refid))
                        result[key] = newrefs
                results_data.append(result)
            data = json.dumps({'result': results_data})

        return HttpResponse(data)

    else:
        # method is not POST
        return HttpResponse("{'status':'error', 'reason':'pls use POST method'}")


@logged_in
@project_verified
def get_project(request, **kwargs):
    if request.method == 'GET':
        pid = ObjectId(kwargs['pid'])
        project = db_read.project.find_one({'pid': pid})
        if project is None:
            return HttpResponse("{'status': 'error','reason':'project not found'}")
        nodeset = []
        linkset = []
        for noderef_id in project['node']:
            noderef = db_read.node_ref.find_one({'_id': noderef_id})
            node_id = noderef['node_id']
            node = db_read.node.find_one({'_id': node_id})
            data = {
                '_id': str(node_id),
                'ref_id': str(noderef_id),
                'NAME': node['NAME'],
                'TYPE': node['TYPE'],
                'x': noderef['x'],
                'y': noderef['y'],
            }
            nodeset.append(data)
        for linkref_id in project['link']:
            linkref = db_read.link_ref.find_one({'_id': linkref_id})
            link_id = linkref['link_id']
            link = db_read.link.find_one({'_id': link_id})
            data = {
                '_id': str(link_id),
                'ref_id': str(linkref_id),
                'TYPE': link['TYPE'],
                'id1': str(linkref['id1']),
                'id2': str(linkref['id2']),
            }
            if 'NAME' in link.keys():
                data['NAME'] = link['NAME']
            linkset.append(data)

        data = {'status': 'success', 'node': nodeset, 'link': linkset}
        return HttpResponse(json.dumps(data))
    else:
        return HttpResponse("{'status': 'error','reason':'pls use method GET'}")


@logged_in
@project_verified
def test_prj(request):
    prj = ProjectFile.objects.get(pk=ObjectId(request.POST['pid']))
    return HttpResponse(prj.name + ' ' + prj.author.username)


