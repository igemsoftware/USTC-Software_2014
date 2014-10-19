__author__ = 'feiyicheng'

from django.shortcuts import HttpResponse, HttpResponsePermanentRedirect
# from django.contrib.auth.models import User
from mongoengine.django.auth import User
# from rest_framework.authtoken.models import Token
from my_auth.models import Token_mongo
from django.core.exceptions import ObjectDoesNotExist, MultipleObjectsReturned
import json
from urllib import urlencode
from OAuthClient import OAuthClientGoogle
from socialoauth import SocialSites, SocialAPIError
from .settings import SOCIALOAUTH_SITES
from my_auth.models import genPassword


def login_start_google(request):
    """ a method that loads config and redirect to Google
    """

    oauthclientgoogle = OAuthClientGoogle()

    authorization_code_req = {
        'response_type': 'code',
        'client_id': oauthclientgoogle.CLIENT_ID,
        'redirect_uri': oauthclientgoogle.REDIRECT_URL,
        'scope': r'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email',
        'state': 'something'
    }

    URL = oauthclientgoogle.BASE_URL + "auth?%s" % urlencode(authorization_code_req)
    # return HttpResponse("{'url':'%s'}" % (URL,))
    return HttpResponsePermanentRedirect(URL)


def login_complete_google(request):
    """
    a method that get UserInfo from Google, log in or create a user, and finally return a token
    with which the user can log in to our server.

    """

    oauthclientgoogle = OAuthClientGoogle()

    print('get code from google')
    # get tokens

    para = request.GET

    tokens = oauthclientgoogle.retrieve_tokens(para)
    # print(str(tokens))
    access_token = tokens['access_token']

    profile = oauthclientgoogle.get_info(access_token)
    # print(str(profile))
    profile['username'] = profile['email']
    profile['uid'] = profile['email']
    # login the user
    # return HttpResponse('profile get\n' + str(profile))

    (user, token) = _get_user_and_token(profile)
    if user:
        data = {
            'status': 'success',
            'token': token.token,
            'uid': str(user.pk),
            'googleid': user.username,
        }
    else:
        data = {
            'status': 'error',
            'reason': 'cannot find or create user, pls contact us',
        }

    return HttpResponse(json.dumps(data))


def login_start_baidu(request):
    """ a method that loads config and redirect to Google
    """

    site = SocialSites(SOCIALOAUTH_SITES).get_site_object_by_name('baidu')
    authorize_url = site.authorize_url
    return HttpResponsePermanentRedirect(authorize_url)


def login_complete_baidu(request):
    """
    a method that get UserInfo from Baidu, log in or create a user, and finally return a token
    with which the user can log in to our server.

    """

    code = request.GET.get('code')
    if not code:
        data = {
            'status': 'error',
            'reason': 'cannot find or create user, pls contact us',
        }
        return HttpResponse(json.dumps(data))
    site = SocialSites(SOCIALOAUTH_SITES).get_site_object_by_name('baidu')

    try:
        site.get_access_token(code)
    except SocialAPIError as e:
        data = {
            'status': 'error',
            'reason': e.error_msg,
        }
        return HttpResponse(json.dumps(data))

    profile = dict()
    profile['username'] = site.name
    profile['uid'] = site.uid
    profile['given_name'] = ''
    profile['family_name'] = ''
    profile['email'] = ''
    (user, token) = _get_user_and_token(profile)
    if user:
        data = {
            'status': 'success',
            'token': token.token,
            'uid': str(user.pk),
            'baiduName': profile['username'],
        }
    else:
        data = {
            'status': 'error',
            'reason': 'cannot find or create user, pls contact us',
        }
    return HttpResponse(json.dumps(data))


def _get_user_and_token(profile):
    """ get user with the given UserInfo(email as the primary key), \
    log in the existed or create a new one, return a token

    :param profile: information get from Google with OAuth access_token
    :return: it will be a tuple of (user, token) if everything goes right, otherwise None
    """

    user, created = User.objects.get_or_create(username=profile['username'])
    _update_user(user, profile)
    token, created = Token_mongo.objects.get_or_create(user=user, token=genPassword(20))
    return (user, token) if user else (None, None)


def _update_user(user, profile):
    """ update user info with the newest information get from OAuth

    :param user: (User object)the user whose profile needs to update
    :param profile: (dict)the source of new info
    :return: None
    """
    try:
        user.first_name = profile['given_name']
        user.last_name = profile['family_name']
        user.email = profile['email']
    except AttributeError, e:
        raise e
    except KeyError, e:
        raise e
    return None




