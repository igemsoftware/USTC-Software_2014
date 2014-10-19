__author__ = 'feiyicheng'

from mongoengine.document import Document
from mongoengine.django.auth import User
import mongoengine.fields as fields
import random
import string


class Token_mongo(Document):
    user = fields.ReferenceField(User)
    token = fields.StringField(min_length=20, max_length=20, primary_key=True, unique=True)


def check_token_user():
    for user in User.objects.all():
        stoken = Token_mongo.objects.get(user=user)
        if stoken is None:
            # the user does not have a token
            Token_mongo.objects.create(user=user, token=genPassword(20))

        else:
            # token already exists
            pass


def genPassword(length):
    # generate a random string of <length> chars
    chars = string.ascii_letters+string.digits
    return ''.join([random.choice(chars) for i in range(length)])


