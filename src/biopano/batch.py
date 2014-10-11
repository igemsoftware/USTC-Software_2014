__author__ = 'beibeihome'

from api.views import get_del_addref_node, add_node, add_link, get_del_addref_link
from django.shortcuts import HttpResponse
from django.http import QueryDict
import json
import urllib


def node_batch(request):
    if request.method == 'PATCH':
        #return HttpResponse('Please relocate node by PATCH request')
        try:
            body = QueryDict(request.body)
        except AttributeError:
            return HttpResponse('json.loads failed')
        para_list = json.loads(body['para_list'])
        for para in para_list:
            sub_request = request
            sub_request.body = urllib.urlencode(para)
            _id = para['id']

            receiver = get_del_addref_node(sub_request, _id)
            if receiver.content != "{'status': 'success}":
                return HttpResponse("{'status': 'error', 'id': " + _id + "}")
        return HttpResponse("{'status': 'success}")

    elif request.method == 'POST':
        para_list = request.POST['para_list']
        para_list = json.loads(para_list)
        result_list = []
        for para in para_list:
            sub_request = request
            sub_request.POST = para

            receiver = add_node(sub_request)
            result_list.append(json.loads(receiver.content))
        result_text = json.dumps(result_list)
        return HttpResponse(result_text)

    elif request.method == 'DELETE':
        body = QueryDict(request.body)
        ref_id_list = json.loads(body['para_list'])
        for ref_id in ref_id_list:
            sub_request = request
            sub_request.body = ''
            get_del_addref_node(sub_request, ref_id['id'])

    elif request.method == 'PUT':
        body = QueryDict(request.body)
        para_list = json.loads(body['para_list'])
        result_list = []
        for para in para_list:
            sub_request = request
            sub_request.body = urllib.urlencode(para)
            receiver = get_del_addref_node(sub_request)
            result_list.append(json.loads(receiver.content))
        result_text = json.dumps(result_list)
        return HttpResponse(result_text)


def link_batch(request):
    if request.method == 'POST':
        #return HttpResponse('{"function": "add_batch", "error": "POST method is requested"}')
        para_list = request.POST['para_list']
        para_list = json.loads(para_list)
        result_list = []
        for para in para_list:
            sub_request = request
            sub_request.POST = para

            receiver = add_link(sub_request)
            result_list.append(json.loads(receiver.content))
        result_text = json.dumps(result_list)
        return HttpResponse(result_text)

    elif request.method == 'DELETE':
        body = QueryDict(request.body)
        para_list = json.loads(body['para_list'])
        result_list = []
        for para in para_list:
            sub_request = request
            sub_request.body = urllib.urlencode(para)
            receiver = get_del_addref_link(sub_request)
            result_list.append(json.loads(receiver.content))
        result_text = json.dumps(result_list)
        return HttpResponse(result_text)

    elif request.method == 'PUT':
        body = QueryDict(request.body)
        para_list = json.loads(body['para_list'])
        result_list = []
        for para in para_list:
            sub_request = request
            sub_request.body = urllib.urlencode(para)
            receiver = get_del_addref_link(sub_request, para_list['id'])
            result_list.append(json.loads(receiver.content))
        result_text = json.dumps(result_list)
        return HttpResponse(result_text)



