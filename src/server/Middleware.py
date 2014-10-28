__author__ = "feiyicheng"

# from rest_framework.authtoken.models import Token
from my_auth.models import Token_mongo
from django.shortcuts import HttpResponse
from rest_framework import HTTP_HEADER_ENCODING, exceptions
from mongoengine.django.auth import User, AnonymousUser
from django.http import QueryDict


def get_authorization_header(request):
    """ Return request"s "Authorization:" header

    """
    auth = request.META.get("HTTP_AUTHORIZATION", b"")
    if type(auth) == type(""):
        # Work around django test client oddness
        auth = auth.encode(HTTP_HEADER_ENCODING)
    return auth


class TokenMiddleware(object):
    """ a middleware that authenticate the client

    if 'Authorization' is found in HttpRequest header, the user matching this token will be logged in;
    else if 'Authorization' is not provided, request.user will be an instance of AnonymousUser;
    else the request will be reject with return some error information.

    """
    model = Token_mongo

    def process_request(self, request):
        """ authenticate the user if Token is provide in the HttpRequest header

        if authenticated successfully, the specific user object will be in request.user,
        if the client don"t provide a token, request.user will be a AnonymousUser instance,
        otherwise error with err information

        @return: None if everything goes right
        """

        # PATCH, PUT, DELETE
        if request.method == "GET" or "POST":
            pass
        elif request.method == "PUT":
            request.PUT = QueryDict(request.body)
        elif request.method == "PATCH":
            request.PATCH = QueryDict(request.body)
        elif request.method == "DELETE":
            request.DELETE = QueryDict(request.body)

        # AUTH
        auth = get_authorization_header(request).split()

        if not auth or auth[0].lower() != b"token":
            request.user = AnonymousUser()
            return None

        if len(auth) == 1:
            msg = "Invalid token header. No credentials provided."
            raise exceptions.AuthenticationFailed(msg)
        elif len(auth) > 2:
            msg = "Invalid token header. Token string should not contain spaces."
            raise exceptions.AuthenticationFailed(msg)

        key = auth[1]
        try:
            token = self.model.objects.get(token=key)
        except Exception as e:
            print(e.message)
            return HttpResponse('{"status":"error", "reason":"invalid token"}')


        if not token.user.is_active:
            raise exceptions.AuthenticationFailed("User inactive or deleted")
        request.user = token.user
        return None

    def process_response(self, request, response):
        response.content = response.content.replace("'", "`")



