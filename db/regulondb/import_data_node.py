__author__ = 'feiyicheng'

from toolbox import *


def main():
    basepath = ''
    #basepath = get_base_path()
    if not basepath:
        basepath = './regulondb/collection/node/'

    filepaths = get_dirs(basepath)
    #print filepaths
    for filepath in filepaths:
        if is_txt(filepath) and 'Product' not in filepath and 'RBS' not in filepath:
            nodetype = get_file_name(filepath, 'node')
            save_data('node', filepath, nodetype, 'txt')




