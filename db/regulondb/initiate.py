__author__ = 'feiyicheng'

from toolbox import *
from CONSTANT import db


def main():

    db.link.remove()
    db.node.remove()

    db.product.remove()

    db.count.update({'type': 'node'}, {'type': 'node', 'value': 0})
    db.count.update({'type': 'link'}, {'type': 'link', 'value': 0})
    db.count.update({'type': 'product'}, {'type': 'product', 'value': 0})
