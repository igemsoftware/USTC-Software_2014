__author__ = 'feiyicheng'

from django.conf.urls import patterns, include, url
from django.contrib import admin

admin.autodiscover()

urlpatterns = patterns('',
    # url(r'^oauth/authorize/$', ),
    url(r'^oauth/google/login/$', 'my_auth.view_oauth.login_start_google'),
    url(r'^oauth/google/complete/$', 'my_auth.view_oauth.login_complete_google'),
    # url(r'^oauth/qq/login/$', 'my_auth.view_oauth.login_start_qq'),
    # url(r'^oauth/qq/complete/', 'my_auth.view_oauth.login_complete_qq'),
    url(r'^oauth/baidu/login/$', 'my_auth.view_oauth.login_start_baidu'),
    url(r'^oauth/baidu/complete/', 'my_auth.view_oauth.login_complete_baidu'),
    # url(r'^test/login/$', 'my_auth.view_token.login'),
    # url(r'^test/logout/$', 'my_auth.view_token.logout')

    # url(r'^token/new/$', 'my_auth.view_token.token_new'),
)



