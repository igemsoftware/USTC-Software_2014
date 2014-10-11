__author__ = 'Beibeihome'
from mongoengine import *


class count(Document):
    type = StringField()
    value = IntField()


class node(DynamicDocument):
    ID = IntField()
    NAME = StringField()
    TYPE = StringField()
    NAME_KEGG = StringField()
    FATHER = ListField(ReferenceField('self'), default=[])
    CHILD = ListField(ReferenceField('self'), default=[])
    EDGE = ListField(ObjectIdField(), default=[])


class link(DynamicDocument):
    ID = IntField()
    NODE1 = ReferenceField(node)
    TYPE1 = StringField()
    NODE2 = ReferenceField(node)
    TYPE2 = StringField()


def kegg_split(file):
    """parametre file must open a kegg-form file,
    and this function will translate file to list named 'pattern'
    which store things like this:['Entry','NAME'......].Also will
    return a list named 'text'save string of pattern
    """
    DEBUG_MODE = False
    parse_dict = {}
    line = file.readline()
    field_name = ''    #store title like 'Entry' and
    text_string = ''    #save text between fieldname

    count = 0
    while r'///' not in line:
        if not line.startswith(' '):
            if line.split()[0] not in parse_dict:
                if parse_dict:
                    # This line include a field name
                    parse_dict[field_name] = text_string
                field_name = line.split()[0]
                parse_dict[field_name] = ''
                text_string = line[len(field_name):]
            else:
                # Think of one field name show up several time
                line = line.split()[1]
                text_string = ''.join([text_string, line])


        else:
            # This line belong to previous field
            text_string = ''.join([text_string, line])
        line = file.readline()
        count += 1
    else:
        parse_dict[field_name] = text_string
    if DEBUG_MODE:
        print 'Number of lines be readed in' + str(count)
    return parse_dict