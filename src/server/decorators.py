__author__ = "feiyicheng"

# from rest_framework.authtoken.models import Token
from mongoengine.django.auth import User, AnonymousUser
from django.shortcuts import HttpResponse
from django.http import QueryDict
from projects.models import ProjectFile
from django.core.exceptions import ObjectDoesNotExist
from bson.objectid import ObjectId


def logged_in(func):
    """a decorator that ensures that the user is logged in

    @param func: a method that requires the user to be logged in.
    """

    def wrap(request, *args, **kwargs):
        # try:
        if isinstance(request.user, AnonymousUser):
            # user not logged in
            return HttpResponse('{"status":"error","reason":"this operation need the user to be logged in"}')
        elif isinstance(request.user, User):
            # user already logged in
            return func(request, *args, **kwargs)
        else:
            raise TypeError("user type should be either User or AnonymousUser")
            # except AttributeError:
            # raise AttributeError("request does not has attribute user")

    wrap.__doc__ = func.__doc__
    wrap.__name__ = func.__name__

    return wrap


def project_verified(func):
    """ a decorator that identify the project

    the request body should be in JSON format with a key names 'pid', and this decorator
    will verify the project with pid with the user logged in.If 'pid' is not provided or
    the project pid represents do not match the logged-in user, it will return Error with
    some error information

    @param func: a method tha needs to verify the user"s group
    """

    def wrap(request, *args, **kwargs):
        data = QueryDict(request.body)
        if "pid" not in data.keys():
            return func(request, *args, **kwargs)
        else:
            try:
                prj = ProjectFile.objects.get(pk=ObjectId(data["pid"]))
            except ObjectDoesNotExist:
                return HttpResponse('{"status":"error", "reason":"cannot find a project matching given pid"}')
            else:
                if request.user == prj.author or request.user in prj.collaborators:
                    return func(request, *args, **kwargs)
                else:
                    return HttpResponse('{"status":"error", "reason":"the project cannot match the user logged in"}')

    wrap.__doc__ = func.__doc__
    wrap.__name__ = func.__name__

    return wrap


def logged_in_exclude_get(func):
    """ verify user logged in except the request user the GET method

    almost the same as logged_in(func)
    """

    def wrap(request, *args, **kwargs):
        try:
            if isinstance(request.user, AnonymousUser):
                # user not logged in
                if request.method == "GET":
                    return func(request, *args, **kwargs)
                else:
                    return HttpResponse('{"status":"error","reason":"this operation need the user to be logged in"}')
            elif isinstance(request.user, User):
                # user already logged in
                return func(request, *args, **kwargs)
            else:
                raise TypeError("user type should be either User or AnonymousUser")
        except AttributeError:
            raise AttributeError("request does not has attribute user")


    wrap.__doc__ = func.__doc__
    wrap.__name__ = func.__name__

    return wrap


def project_verified_exclude_get(func):
    """ verify user logged in with the project except the request user the GET method

    almost the same as project_verified(func)
    """

    def wrap(request, *args, **kwargs):
        if request.method == "GET":
            return func(request, *args, **kwargs)
        data = QueryDict(request.body)
        if "pid" not in data.keys():
            return func(request, *args, **kwargs)
        else:
            try:
                prj = ProjectFile.objects.get(pk=ObjectId(data["pid"]))

            except ObjectDoesNotExist:
                return HttpResponse('{"status":"error", "reason":"cannot find a project matching given pid"}')
            else:
                if request.user == prj.author or request.user in prj.collaborators:
                    return func(request, *args, **kwargs)
                else:
                    return HttpResponse('{"status":"error", "reason":"the project cannot match the user logged in"}')

    wrap.__doc__ = func.__doc__
    wrap.__name__ = func.__name__

    return wrap
