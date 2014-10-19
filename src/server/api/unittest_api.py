__author__ = 'feiyicheng'

import unittest
import random
import sys
from django.http.request import HttpRequest
# from django.contrib.auth.models import User
from mongoengine.django.auth import User
import json

from .views import *


class ApiTestClass(unittest.TestCase):

    def setUp(self):
        self.request = HttpRequest()
        self.request.META['Authorization'] = "Token 3a85b0086a82e5d8cd093277fde205d453f2b71e"
        user = User.objects.get(pk=1)
        self.request.user = user
        pass

    def tearDown(self):
        self.request = None
        pass

    def search_json_node(self):
        request = self.request
        request.method = 'POST'
        spec = "{'TYPE': 'Gene'}"
        fields = "{'NAME':1,'_id':1}"
        request.POST = {
            'spec': spec,
            'fields': fields,
        }
        response = search_json_node(request)
        is_json_formated = False
        try:
            json.loads(response.content)
        except Exception as e:
            pass
        else:
            is_json_formated = True

        self.assertTrue(is_json_formated, msg="response is not json formatted")
        self.tearDown()
        self.setUp()

    def search_json_link(self):
        request = self.request
        request.method = 'POST'
        spec = "{'TYPE1': 'Gene'}"
        request.POST = {
            'spec': spec,
        }
        response = search_json_link(request)
        is_json_formated = False
        try:
            json.loads(response.content)
        except Exception as e:
            pass
        else:
            is_json_formated = True

        self.assertTrue(is_json_formated, msg="response is not json formatted")
        self.tearDown()
        self.setUp()

    def get_project(self):
        request = self.request
        err_num = 0
        success_num = 0

        testpids = [random.randint(1, 200) for i in xrange(10)]
        for testpid in testpids:
            response = get_project(request, {'pid': testpid})
            answer = json.loads(response.content)
            # if not answer.has_key('status'):
            #     raise TypeError("the key 'status' should be in the reponse.content")
            # if answer['status'] == 'success':
            #     success_num += 1
            # elif answer['status'] == 'error':
            #     err_num += 1
        self.assertIn('status', answer.keys(), msg="the object should have key 'status'")

        self.tearDown()
        self.setUp()


def suite():
    suite = unittest.TestSuite()
    suite.addTest("search_json_node")
    suite.addTest("search_json_link")
    suite.addTest("get_project")
    return suite


if __name__ == '__main__':
    unittest.main()
