__author__ = 'feiyicheng'


def validate_node(dic):
    """
    :param dic: the information of the node to be added
    :return:True or false
    """
    if (not 'NAME' in dic) or (not 'TYPE' in dic):
        return False
    return True


def validate_link(dic):
    """
    :param dic: the information of the link to be added
    :return:True or false
    """
    return True


def validate(dic):
    return True
