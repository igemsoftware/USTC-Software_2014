__author__ = 'feiyicheng'

from django.conf.urls import patterns, include, url
import views
from django.contrib import admin

admin.autodiscover()

urlpatterns = patterns('',
    url(r'^node/$', 'api.views.search_json_node'),    # POST
    url(r'^link/$', 'api.views.search_json_link'),  # POST
    url(r'^user/$', 'projects.views.search_user'),  #
    url(r'^project/$', 'projects.views.search'),  # POST
)

