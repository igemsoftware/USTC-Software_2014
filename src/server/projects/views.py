__author__ = 'feiyicheng'

from pymongo import MongoClient
from django.shortcuts import HttpResponse
# from django.contrib.auth.models import User
from mongoengine.django.auth import User
from mongoengine.queryset import Q
from django.core.exceptions import ObjectDoesNotExist
import json
# from .models import Project
from .models import ProjectFile
from decorators import logged_in
from django.http import QueryDict
from IGEMServer.settings import db
from bson.objectid import ObjectId


def search(request, *args, **kwargs):
    """
    search for projects by name or author(support fuzzy search)
    :param request: request object
    :param args: do not matter in this method
    :param kwargs: keyword arguments
    :return: results or error information in JSON format
    """
    if request.method == 'POST':
        try:
            para = request.POST['query']
        except KeyError:
            return HttpResponse("{'status':'error', 'reason':'your POST paras should have a field named query'}")

        try:
            para = json.loads(para)
        except:
            return HttpResponse("{'status':'error', 'reason':'requet string not conform to json format'}")

        author_id = para['authorid']

        try:
            prj_name = para['name']
        except KeyError:
            prj_name = None

        if not author_id and not prj_name:
            return HttpResponse("{'status':'error', 'reason':'your query contains neither author nor name'}")

        if author_id:
            if prj_name:
                results = ProjectFile.objects.filter(name__icontains=prj_name,
                                                 author=User.objects.get(pk=ObjectId(author_id)))
            else:
                results = ProjectFile.objects.filter(author=User.objects.get(pk= ObjectId(author_id)))
        else:
            results = ProjectFile.objects.filter(name__icontains=prj_name)

        clean_results = []
        for result in results:
            clean_result = {
                'author': result.author.username,
                'authorid': str(result.author.pk),
                'pid': str(result.pk),
                'name': result.name,
                'collaborators': [str(coll.pk) for coll in result.collaborators],
            }
            clean_results.append(clean_result)

        data_dict = {'status': 'success', 'results': clean_results}
        return HttpResponse(json.dumps(data_dict))
    else:
        return HttpResponse("{'status':'error', 'reason':'method not correct'}")


@logged_in
def del_project(request, *args, **kwargs):
    """
    delete a porject of the user's own
    :param request: request object
    :param args: nonsense
    :param kwargs: kwargs['prj_id']
    :return:
    """
    if request.method == 'GET':
        user = request.user
        prj_id = kwargs['prj_id']
        if not prj_id:
            return HttpResponse("{'status':'error', 'reason':'prj_id not found'}")

        if user.is_authenticated():
            if _is_author(prj_id, user):
                # the user operating is the author of the project, he/she has the power to delete id
                ProjectFile.objects.get(pk=ObjectId(prj_id)).delete()
                return HttpResponse("{'status':'success'}")

            else:
                return HttpResponse("{'status':'error', 'reason':'No access! Only the author of the project \
                has the right to delete it'}")
        else:
            return HttpResponse("{'status':'error', 'reason':'user not logged in'}")
    else:
        return HttpResponse("{'status':'error', 'reason':'method not correct'}")


@logged_in
def modify_project(request, *args, **kwargs):
    """ a api to modify the project profile

    @param request: django request object
    @para kwargs: kwargs['prj_id'] is the id of the
    @return: success or error information
    """

    # POST paras should cover all fields expected to be modified
    if request.method == 'PUT':
        user = request.user
        prj_id = kwargs['prj_id']
        query = request.POST
        if not prj_id:
            return HttpResponse("{'status':'error', 'reason':'prj_id not found'}")

        if user.is_authenticated():
            if _is_author(prj_id, user):
                try:
                    project = ProjectFile.objects.get(pk=ObjectId(prj_id))
                except ObjectDoesNotExist as e:
                    return HttpResponse("{'status':'error', 'reason':'cannot find project with that id'}")

                prj_attrs = ['name', 'description', 'species']
                for key in query.keys():
                    if key not in prj_attrs:
                        return HttpResponse("{'status':'error', 'reason':'field invalid!'}")
                    try:
                        exec ("project.{0} = query['{1}']".format(key, key))
                        project.save()
                    except Exception as e:
                        return HttpResponse("{'status':'error', 'reason':'wrong key provided'}")

                return HttpResponse("{'status':'success', 'prj_id':%s}" % str(project.pk))
            else:
                return HttpResponse("{'status':'error', 'reason':'No access! Only the author of the project \
                has the right to delete it'}")
        else:
            return HttpResponse("{'status':'error', 'reason':'user not logged in'}")


@logged_in
def add_or_del_collaborator(request, *args, **kwargs):
    if request.method == 'DELETE':
        user = request.user
        prj_id = kwargs['prj_id']
        uid = int(kwargs['uid'])
        if prj_id is None:
            return HttpResponse("{'status':'error', 'reason':'prj id should be a integer'}")
        if _is_author(prj_id, user):
            project = ProjectFile.objects.get(pk=ObjectId(prj_id))
            coll = User.objects.get(pk=ObjectId(uid))
            if coll in project.collaborators:
                project.collaborators.remove(coll)
                return HttpResponse("{'status':'success'}")
            else:
                return HttpResponse("{'status':'error', 'reason':'the user is not in collaborators'}")

        else:
            return HttpResponse("{'status':'error', 'reason':'only author of the project have access to do this'}")

    elif request.method == 'POST':
        user = request.user
        prj_id = kwargs['prj_id']
        if not prj_id:
            return HttpResponse("{'status':'error', 'reason':'prj_id should be a integer'}")

        uid = int(kwargs['uid'])

        if not _is_author(prj_id, user):
            # the user is not the author of the project
            return HttpResponse("{'status':'error', 'reason':'No access! Only the author of the project \
                has the right to delete it'}")

        if user.is_authenticated():

            prj = ProjectFile.objects.get(pk=ObjectId(prj_id))
            try:
                collaborator = User.objects.get(pk=ObjectId(uid))
            except ObjectDoesNotExist:
                return HttpResponse("{'status':'error', 'reason':'cannot find a user matching the input username'}")
            prj.collaborators.append(collaborator)
            return HttpResponse("{'status':'success'}")
        else:
            return HttpResponse("{'status':'error', 'reason':'user not logged in'}")
    else:
        return HttpResponse("{'status':'error', 'reason':'method not correct(should be DELETE)'}")


@logged_in
def list_or_create(request, *args, **kwargs):
    """ show the user's all projects with GET or create a new project with POST

    @return: success or error with information
    """
    if request.method == 'GET':
        user = request.user
        clean_results = []

        results_author = [project for project in ProjectFile.objects.all() if project.author == user]
        for result in results_author:
            if result.is_active:
                clean_result = {
                    'author': result.author.username.encode('ascii', 'replace'),
                    'authorid': str(result.author.pk),
                    'pid': str(result.pk),
                    'name': result.name.encode('ascii', 'replace'),
                }
                clean_results.append(clean_result)

        results_collaborated = [project for project in ProjectFile.objects.all() if user in project.collaborators]
        for result in results_collaborated:
            if result.is_active:
                clean_result = {
                    'author': result.author.username.encode('ascii', 'replace'),
                    'authorid': str(result.author.pk),
                    'pid': str(result.pk),
                    'name': result.name.encode('ascii', 'replace'),
                }
                clean_results.append(clean_result)

        data_dict = {'status': 'success', 'results': clean_results}
        return HttpResponse(json.dumps(data_dict))

    elif request.method == 'POST':
        user = request.user
        paras = request.POST
        try:
            prj_name = paras['prj_name']
        except KeyError:
            return HttpResponse("{'status':'error', 'reason':'POST paras should include prj_name'}")

        try:
            if user.is_authenticated():
                new_prj = ProjectFile.objects.create(name=prj_name, author=user, is_active=True)
                attrset = ['description', 'species']

                for key in paras.keys():
                    if not key in attrset:
                        if key == 'prj_name':
                            pass
                        else:
                            return HttpResponse("{'status':'error', 'reason':'attribute error'}")
                    else:
                        exec("new_prj.{0} = paras['{1}']".format(key, key))
                        new_prj.save()
                db.project.insert({'pid': new_prj.pk, 'node': [], 'link': []})

                return HttpResponse("{'status':'success','pid':'%s'}" % (str(new_prj.pk), ))
        except AttributeError:
            raise AttributeError("hehe")

    else:
        return HttpResponse("{'status':'error', 'reason':'method not correct(GET or POST needed)'}")


@logged_in
def get_one(request, *args, **kwargs):
    if request.method == 'GET':
        user = request.user
        prj_id = kwargs['prj_id']
        if not prj_id:
            return HttpResponse("{'status':'error', 'reason':'prj_id not found'}")

        if user.is_authenticated():
            try:
                project = ProjectFile.objects.get(pk=ObjectId(prj_id))
            except ObjectDoesNotExist:
                return HttpResponse("{'status':'error', 'reason':'cannot find project matching the given id'}")
            if not (user == project.author or user in project.collaborators):
                return HttpResponse("{'status':'error', 'reason':'you dont have the access to the whole profile'}")
            else:
                clean_result = {
                    'author': project.author.username.encode('ascii', 'replace'),
                    'authorid': str(project.author.pk),
                    'pid': str(project.pk),
                    'prj_name': project.name.encode('ascii', 'replace'),
                    'species': project.species.encode('ascii', 'replace'),
                    'description': project.description.encode('ascii', 'replace'),
                    'collaborators': [{'uid': str(coll.pk), 'username': coll.username} for coll \
                                      in project.collaborators],
                }
            data_dict = {'status': 'success', 'result': clean_result}
            return HttpResponse(json.dumps(data_dict))

        else:
            return HttpResponse("{'status':'error', 'reason':'you should be logged in'}")
    elif request.method == 'PUT':
        user = request.user
        prj_id = kwargs['prj_id']
        query = QueryDict(request.body)
        if not prj_id:
            return HttpResponse("{'status':'error', 'reason':'prj_id not found'}")

        if user.is_authenticated():
            if _is_author(prj_id, user):
                try:
                    project = ProjectFile.objects.get(pk=ObjectId(prj_id))
                except ObjectDoesNotExist as e:
                    return HttpResponse("{'status':'error', 'reason':'cannot find project with that id'}")

                prj_attrs = ['name', 'description', 'species']
                for key in query.keys():
                    if key not in prj_attrs:
                        return HttpResponse("{'status':'error', 'reason':'field invalid!'}")
                    try:
                        exec ("project.{0} = query['{1}']".format(key, key))
                        project.save()
                    except Exception as e:
                        return HttpResponse("{'status':'error', 'reason':'wrong key provided'}")

                return HttpResponse("{'status':'success', 'prj_id':%s}" % str(project.pk))

            else:
                return HttpResponse("{'status':'error', 'reason':'No access! Only the author of the project \
                has the right to delete it'}")
        else:
            return HttpResponse("{'status':'error', 'reason':'user not logged in'}")

    elif request.method == 'DELETE':
        user = request.user
        prj_id = kwargs['prj_id']
        if not prj_id:
            return HttpResponse("{'status':'error', 'reason':'prj_id not found'}")

        if user.is_authenticated():
            if _is_author(prj_id, user):
                # the user operating is the author of the project, he/she has the power to delete id
                ProjectFile.objects.get(pk=ObjectId(prj_id)).delete()
                return HttpResponse("{'status':'success'}")

            else:
                return HttpResponse("{'status':'error', 'reason':'No access! Only the author of the project \
                has the right to delete it'}")
        else:
            return HttpResponse("{'status':'error', 'reason':'user not logged in'}")

    else:
        return HttpResponse("{'status':'error', 'reason':'method not correct(GET,DELETE or PUT needed)'}")


@logged_in
def search_user(request, *args, **kwargs):
    """ search user using name (fuzzy search)

    POST method needed
    POST:  name: zhoul

    @return: success or error information
    """

    if request.method == 'POST':
        if 'name' not in request.POST:
            return HttpResponse("{'status':'error', 'reason':'you should provide name field'}")
        else:
            value = request.POST['name']
            resultset = User.objects.filter(Q(username__icontains=value) | Q(first_name__icontains=value) | \
                                            Q(first_name__icontains=value))
            clean_results = []
            for result in resultset:
                clean_result = {
                    'username': result.username,
                    'first_name': result.first_name,
                    'last_name': result.last_name,
                    'id': str(result.pk),
                }
                clean_results.append(clean_result)

            data_dict = {'status': 'success', 'results': clean_results}

            return HttpResponse(json.dumps(data_dict))

    else:
        return HttpResponse("{'status':'error', 'reason':'method not correct(should be POST)'}")


'''
def switch_project(request, *args, **kwargs):
    user = request.user
    prj = _get_prj_id_int(kwargs['prj_id'])
    if not _has_access(prj, user):
        return HttpResponse("{'status':'error', 'reason':'You dont have access to do this'}")
    else:
        user.userprofile.currentProject = prj
        return HttpResponse("{'status':'success', 'id':'%d'}" % (prj.id, ))
'''

#
# def _get_prj_id_int(prj_id_str):
#     """
#     convert a string to in else return None
#     :param prj_id_str: a number in string format
#     :return:
#     """
#     try:
#         prj_id = int(prj_id_str)
#     except ValueError:
#         return None
#     else:
#         return prj_id


def _is_author(prj_id, user):
    """

    :param prj_id: the project id (integer)
    :param user:  the user object
    :return: True if the user is the author of the project else False
    """
    prj = ProjectFile.objects.get(pk=ObjectId(prj_id))
    if user == prj.author:
        return True
    else:
        return False


def _has_access(prj, user):
    if prj in user.projects_authored.all() or prj in user.projects_collaborated.all():
        return True
    else:
        return False
