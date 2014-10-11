__author__ = 'feiyicheng'

from django.conf.urls import patterns, include, url
import views
from django.contrib import admin

admin.autodiscover()

urlpatterns = patterns('',
    url(r'^node/$', views.add_node),    # POST
    url(r"^node/(?P<id>[\w]+)/$", views.get_del_addref_node),  # DELETE / PUT / GET

    url(r'^link/$', views.add_link),    # POST
    url(r'^link/(?P<id>[\w]+)/$', views.get_del_addref_link),  # DELETE / PUT / GET

    url(r'^project/(?P<pid>[\w]+)/$', views.get_project),
    url(r'^test/$', views.test_prj)
)