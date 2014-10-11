__author__ = 'feiyicheng'

from toolbox import *



def main():
    basepath = ''
    #basepath = get_base_path()
    if not basepath:
        basepath = './regulondb/collection/link/'

    filepaths = get_dirs(basepath)
    for filepath in filepaths:
        if is_txt(filepath):
            nodetype = get_file_name(filepath, 'link')
            save_data('link', filepath, nodetype, 'txt')
