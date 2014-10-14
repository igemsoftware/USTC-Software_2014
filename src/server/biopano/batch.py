__author__ = 'beibeihome'

from api.views import get_del_addref_node, add_node, add_link, get_del_addref_link
from django.shortcuts import HttpResponse
from django.http import QueryDict
import json
import urllib


def batch(request):
    order_list_str = request.POST['orderlist']
    order_list = json.loads(order_list_str)
    result_list = []
    for order in order_list:
        if 'PATCH_NODE'in order.keys():
            #return HttpResponse('Please relocate node by PATCH request')
            one_order_result = []
            para_list = order['PATCH_NODE']
            for para in para_list:
                sub_request = request
                sub_request.POST = para
                sub_request.method = 'PATCH'

                receiver = get_del_addref_node(sub_request, ID=str(para['ID']))
                #one_order_result.append(json.loads(receiver.content))
            #result_list.append(one_order_result)

        elif 'ADD_NODE' in order.keys():
            para_list = order['ADD_NODE']
            one_order_result = []
            for para in para_list:
                sub_request = request
                sub_request.POST = para

                receiver = add_node(sub_request)
                one_order_result.append(json.loads(receiver.content))
            result_list.append(one_order_result)

        elif 'DELETE_NODE' in order.keys():
            ref_id_list = order['DELETE_NODE']
            one_order_result = []
            for ref_id in ref_id_list:
                sub_request = request
                sub_request.POST = ref_id
                sub_request.method = 'DELETE'
                receiver = get_del_addref_node(sub_request, ID=str(ref_id['ID']))
                #one_order_result.append(json.loads(receiver.content))
            #result_list.append(one_order_result)

        elif 'PUT_NODE'in order.keys():
            para_list = order['PUT_NODE']
            one_order_result = []
            for para in para_list:
                sub_request = request
                sub_request.POST = para
                sub_request.method = 'PUT'
                receiver = get_del_addref_node(sub_request, ID=str(para['ID']))
                #one_order_result.append(json.loads(receiver.content))

            #result_list.append(one_order_result)

        elif 'ADD_LINK' in order.keys():
            #return HttpResponse('{"function": "add_batch", "error": "POST method is requested"}')
            para_list = order['ADD_LINK']
            one_order_result = []
            for para in para_list:
                sub_request = request
                sub_request.POST = para

                receiver = add_link(sub_request)
                one_order_result.append(json.loads(receiver.content))
            result_list.append(one_order_result)

        elif 'DELETE_LINK'in order.keys():
            para_list = order['DELETE_LINK']
            one_order_result = []
            for para in para_list:
                sub_request = request
                sub_request.POST = para
                sub_request.method = 'DELETE'
                receiver = get_del_addref_link(sub_request, ID=str(para['ID']))
                #one_order_result.append(json.loads(receiver.content))
            #result_list.append(one_order_result)

        elif 'PUT_LINK' in order.keys():
            para_list = order['PUT_LINK']
            one_order_result = []
            for para in para_list:
                sub_request = request
                sub_request.POST = para
                sub_request.method = 'PUT'
                receiver = get_del_addref_link(sub_request, ID=str(para['ID']))
                #one_order_result.append(json.loads(receiver.content))
            #result_list.append(one_order_result)
    result_text = json.dumps(result_list)
    return HttpResponse(result_text)




