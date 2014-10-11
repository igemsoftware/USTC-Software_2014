__author__ = 'feiyicheng'

from toolbox import *

def main():

    basepath = ''
    #basepath = get_base_path()
    if not basepath:
        basepath = './regulondb/father/'

    filepaths = get_dirs(basepath)
    for filepath in filepaths:
        if is_excel(filepath):
            add_ref_father(filepath)
