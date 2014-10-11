__author__ = 'feiyicheng'

import urllib2, urllib
import json
from urllib import urlencode, unquote
import re
import socket
from ssl import SSLError
import IGEMServer.settings as settings


class OAuthClientBase(object):
    """ a OAuthClient manager that encapsulate the oauth steps into several methods
    """

    def __init__(self):
        self.CLIENT_ID = ''
        self.CLIENT_SECRET = ''
        self.REDIRECT_URL = ''
        self.BASE_URL = ''
        self.TOKEN_METHOD = ''
        self.AUTHORIZATION_CODE_REQ = None

    def retrieve_tokens(self, para):
        """ this method will automatically retrieve the OAuth token from the OAuth server

        @tag: this method is not used in the whole project
        """

        authorization_token_req = {
            'code': para['code'],
            'client_id': self.CLIENT_ID,
            'client_secret': self.CLIENT_SECRET,
            'redirect_uri': self.REDIRECT_URL,
            'grant_type': 'authorization_code',
        }

        cleanurl = self.BASE_URL + 'token'

        if self.TOKEN_METHOD == 'GET' or self.TOKEN_METHOD == '':
            url = cleanurl + '?' + urlencode(authorization_token_req)
            tokens_origin = urllib2.urlopen(url).read()
            access_token = re.match(r'access_token=(.+)&.*', tokens_origin).group(1)
            expires_in = re.match(r'in=(.+).*', tokens_origin).groups(1)
            self.USER_INFO_REQ['access_token'] = access_token
            return {'access_token': access_token, 'expires_in': expires_in}

        elif self.TOKEN_METHOD == 'POST':
            data = urllib.urlencode(authorization_token_req)
            req = urllib2.Request(cleanurl, data)
            req.add_header('Content-Type', 'application/x-www-form-urlencoded')
            # req.add_header('Host', 'accounts.google.com')
            response = urllib2.urlopen(req)
            tokens_origin = response.read()
            return json.loads(tokens_origin)
        else:
            pass


class OAuthClientGoogle(OAuthClientBase):
    """ a client manager tha encapsulate the OAuth step into several methods

    when an instance is created, it will load OAuth configs(redirect_url, id, secret) from SETTINGS
    """

    def __init__(self):
        self.CLIENT_ID = settings.OAuthClient['google']['CLIENT_ID']
        self.CLIENT_SECRET = settings.OAuthClient['google']['CLIENT_SECRET']
        self.REDIRECT_URL = settings.OAuthClient['google']['REDIRECT_URL']
        self.BASE_URL = settings.OAuthClient['google']['BASE_URL']
        self.TOKEN_METHOD = 'POST'

        self.AUTHORIZATION_CODE_REQ = {
            'response_type': 'code',
            'client_id': self.CLIENT_ID,
            'redirect_uri': self.REDIRECT_URL,
            'scope': r'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email',
            'state': 'something'
        }

    def retrieve_tokens(self, para):
        """ this method will automatically retrieve the OAuth token from the OAuth server

        @para para: a dict with a key named "code"(the code from Google)
        @type para: dict
        @return: a dict with token and other extra information
        """

        authorization_token_req = {
            'code': para['code'],
            'client_id': self.CLIENT_ID,
            'client_secret': self.CLIENT_SECRET,
            'redirect_uri': self.REDIRECT_URL,
            'grant_type': 'authorization_code',
        }

        cleanurl = self.BASE_URL + 'token'
        data = urllib.urlencode(authorization_token_req)
        req = urllib2.Request(cleanurl, data)
        req.add_header('Content-Type', 'application/x-www-form-urlencoded')
        # req.add_header('Host', 'accounts.google.com')
        tag = 1
        while 0 < tag < 5:
            try:
                response = urllib2.urlopen(req, timeout=6)
            except SSLError:
                tag += 1
                print('time out !')
                continue
            except Exception, e:
                tag += 1
                print('other errors' + str(e))
                continue
            else:
                break
        try:
            tokens_origin = response.read()
        except Exception as e:
            raise e

        return json.loads(tokens_origin)

    @staticmethod
    def get_info(access_token):
        """ a method that can return the user info with the given

        @param access_token: access_token that can be used to get user info
        @type access_token: string
        @return: a dict with all the user info got from Google server
        """
        url = 'https://www.googleapis.com/oauth2/v1/userinfo?access_token=%s' % (access_token,)
        # profile_json = urllib2.urlopen(url).read()
        tag = 1
        while 0 < tag < 5:
            try:
                response = urllib2.urlopen(url, timeout=6)
            except SSLError:
                tag += 1
                print('time out !')
                continue
            except Exception, e:
                tag += 1
                print('other errors' + str(e))
                continue
            else:
                if tag >= 5:
                    return None
                break
        try:
            profile = json.loads(response.read())
        except Exception as e:
            raise e

        return profile

if __name__ == '__main__':
    pass
