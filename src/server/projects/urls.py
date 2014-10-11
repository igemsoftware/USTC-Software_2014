__author__ = "feiyicheng"

from django.conf.urls import patterns, include, url
import views
from django.contrib import admin

admin.autodiscover()

urlpatterns = patterns('',
    url(r'^search/$', 'projects.views.search'), # search project by author or name

    # url(r'^create/(?P<prj_name>[^/]+)/$', 'projects.views.create_project'),  # create a new project
    # url(r'^addin/(?P<prj_id>[^/]+)$', 'projects.views.add_in_a_project'), # add the user into a project
    # url(r'^delete/(?P<prj_id>\d+)/$', 'projects.views.del_project'), # delete a project
    # url(r'^modify/(?P<prj_id>[^/]+)/$', 'projects.views.modify_project'),
    url(r'^project/$', 'projects.views.list_or_create'),
    url(r'^(?P<prj_id>[^/]+)/$','projects.views.get_one'),
    url(r'^(?P<prj_id>[^/]+)/collaborator/(?P<uid>[^/]+)/$', 'projects.views.add_or_del_collaborator'),
    # url(r'^switch/(?P<prj_id>[^/]+)/$', 'projects.views.switch_project'),
)