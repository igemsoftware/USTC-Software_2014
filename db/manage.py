__author__ = 'Beibeihome'
__version__ = '1.1.1.0'

import os
from pymongo import *
from mongoengine import *
from regulondb import *
from Modules.kegg_parse import node
from CONSTANT import db


OVERWRITE = True

def count():
    db.drop_collection('count')
    db.count.insert({'type': 'node', 'value': 0})
    db.count.insert({'type': 'link', 'value': 0})
    db.count.insert({'type': 'product', 'value': 0})


def regulondb():
    path = './regulondb/manage.py'
    # I don't know what is {} using for,but this function can't be without it
    execfile(path, {})



def regulondb_link():
    path = './regulondb/add_ref.py'
    execfile(path, {})


def product_process():
    path = './regulondb/product.py'
    execfile(path, {})


def kegg_node(number=None):
    basepath = './kegg/'
    #paths = [basepath + 'compound.py', basepath + 'enzyme.py', basepath + 'module.py', basepath + 'protein.py']
    #kind = {'0': 'Compound', '1': 'Enzyme', '2': 'Module', '3': 'Protein'}
    paths = [basepath + 'compound.py', basepath + 'module.py', basepath + 'enzyme.py']
    kind = {'0': 'Compound', '1': 'Module', '2': 'Enzyme'}
    if number == None:
        db.drop_collection('kegg_node')
        for path in paths:
            execfile(path, {})
    else:
        db.node.remove({'TYPE': kind[str(number)]})
        execfile(paths[number], {})


def kegg_reaction():
    path = './kegg/reaction.py'
    #order = 'python ' + path
    #os.system(order)
    db.node.remove({'TYPE': 'Reaction'})
    execfile(path, {})


def kegg_reaction_function_link():
    path = './kegg/mm_parse.py'
    db.drop_collection('module__function_link')
    #order = 'python ' + path
    #os.system(order)
    execfile(path, {})


def database_link():
    path = './database_link/database_link.py'
    #order = 'python ' + path
    #os.system(order)
    execfile(path, {})


def kegg_connect():
    path = './kegg/kegg_link.py'
    execfile(path, {})


def patch1():
    path1 = './regulondb/TU_TF_link.py'
    #execfile(path1, {})
    path2 = './Sequence Analyse/UTR_importing.py'
    execfile(path2, {})


def patch2():
    db.drop_collection('node_ref')
    db.drop_collection('link_ref')
    path = './Patch/Fishing Patch.py'
    execfile(path, {})


def uniprot_update():
    path = uniprot_path = './other/uniprot.py'
    execfile(uniprot_path, {})


def log_create():
    path = './log_create.py'
    execfile(path, {})


def rename_enzyme():
    path = './Patch/rename_enzyme.py'
    execfile(path, {})


def gene_sysname():
    path = './Patch/sysname_gene.py'
    execfile(path, {})


def sort_link():
    path = './Patch/sort_link.py'
    execfile(path, {})


def alignment_data():
    path = './Sequence Analyse/UTR_importing.py'
    execfile(path, {})


def blast_setup():
    path = './Sequence Analyse/alignment.py'
    order = 'makeblastdb -in ./BLAST/sequence.fasta -dbtype nucl -title ustc_blast -parse_seqids -out /tmp/blast/ustc_blast'
    print 'fasta database creating'
    execfile(path, {})
    print 'blast database creating'
    os.system(order)


def project_init():
    path = './Patch/project_init.py'

def sigma_link():
    path = './Patch/sigma_link.py'
    execfile(path, {})


def rebuild():
    if OVERWRITE:
        for collection in db.collection_names():
            if collection not in ['system.indexes', 'system.users']:
                db.drop_collection(collection)
    print 'count log creating'
    count()
    print 'run regulondb importing from super manage.py'
    regulondb()
    print 'product importing '
    product_process()
    print 'run kegg_node importing from super manage.py'
    kegg_node()
    print 'run kegg_reaction importing from super manage.py'
    kegg_reaction()
    print 'run reaction connection from super manage.py'

    db.node.create_index('NAME')
    kegg_connect()
    print 'run reaction function sort from super manage.py'
    kegg_reaction_function_link()
    print 'run link setting between gene and enzyme from super manage.py'
    database_link()

    print 'patch 1 built in August :adding alignment database'
    patch1()

    print 'working log creating'
    log_create()

    print 'uniprot updating'
    uniprot_update()

    print 'kegg rename'
    rename_enzyme()

    print '\nAdd Sysname to Gene'
    gene_sysname()

    print '\n Add sigma link'
    sigma_link()

    print 'Sort link type'
    sort_link()

    print 'BLAST database setup'
    alignment_data()

    print 'Fishing patch built in August 22'
    patch2()

    print 'Initial project information'
    project_init()


def main():
    rebuild()

main()

