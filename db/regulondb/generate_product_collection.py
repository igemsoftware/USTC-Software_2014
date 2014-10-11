__author__ = 'feiyicheng'

from toolbox import *


def main():
    filepath = './regulondb/collection/node/Product.txt'

    nodetype = get_file_name(filepath, 'regulondb')
    save_data('product', filepath, nodetype, 'txt')

