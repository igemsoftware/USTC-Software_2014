__author__ = 'feiyicheng'

from django.test import TestCase
import random
import sys
from django.http.request import HttpRequest
import json

from .views import *


class ProjectsTestClass(TestCase):

    def setUp(self):
        self.request = HttpRequest()
        self.request.META['Authorization'] = "Token 3a85b0086a82e5d8cd093277fde205d453f2b71e"
        user = User.objects.get(pk=1)
        self.request.user = user
        pass

    def tearDown(self):
        self.request = None
        pass
