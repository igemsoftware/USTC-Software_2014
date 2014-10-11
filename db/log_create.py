__author__ = 'Beibeihome'

from pymongo import *
import CONSTANT
import json


db = MongoClient()[CONSTANT.DATABASE]
fp = open(CONSTANT.LOG_PATH, 'w+')
fp_not_found = open('log/not_found_list.txt', 'w+')

num_with_TF = 0
num_with_Enzyme = 0
num_with_RNA = 0


def search_exists(gene_name, gene_exist_list, rna_gene_list):
    global num_with_TF, num_with_Enzyme, num_with_RNA
    #print gene_name
    p_name = gene_name[0].upper() + gene_name[1:]
    #print p_name
    flat = False
    if db.node.find_one({'NAME': p_name, 'TYPE': 'TF'}):
        fp.write('Have TF\n')
        num_with_TF += 1
        flat = True
    if gene_name in gene_exist_list:
        fp.write('Have Enzyme\n')
        num_with_Enzyme += 1
        flat = True
    if gene_name in rna_gene_list:
        fp.write('Have RNA\n')
        num_with_RNA += 1
        flat = True

    return flat


def main():
    num_not_found_in_uniprot = 0
    text = open('./ecoliparse.txt', 'r').read().replace('\'', '\"')
    #print text
    dict = json.loads(text)
    #print dict
    db.drop_collection('uniprot')
    db.uniprot.insert(dict)
    db.uniprot.create_index('gene_name')

    gene_exist_list = []
    gene_multi_exit_list = []
    rna_gene_list = []
    for enzyme in db.node.find({'TYPE': 'Enzyme'}):
        for gene in enzyme['GENES']:
            if gene not in gene_exist_list:
                gene_exist_list.append(gene)
            elif gene not in gene_multi_exit_list:
                gene_multi_exit_list.append(gene)
    for RNA in db.product.find({'TYPE': {'$ne': 'Protein'}}):
        gene = RNA['Gene']
        if gene not in rna_gene_list:
            rna_gene_list.append(gene)
    print 'existed gene list has been built'
    fp.write('coding_gene_list\n\n')
    fp.write(str(gene_exist_list))
    fp.write('\n\ngene which product RNA\n\n')
    fp.write(str(rna_gene_list))
    fp.write('\n\n gene which product multi enzyme\n\n')
    fp.write(str(gene_multi_exit_list))
    #print gene_exist_list

    saved_count = 0
    cursor = db.node.find({'TYPE': 'Gene'}, timeout=False)
    for gene in cursor:

        fp.write(gene['NAME'] + '  ')
        if not search_exists(gene['NAME'], gene_exist_list, rna_gene_list):
            uniprot_name = gene['NAME'].replace('-', '').split('_')[0]
            log = db.uniprot.find_one({'gene_name': uniprot_name})
            if not log:
                fp.write('can\'t be found in uniprot\n')
                fp_not_found.write(gene['NAME'] + '\n')
                num_not_found_in_uniprot += 1
                continue
            fp.write(' should be saved\n')
            saved_count += 1
    cursor.close()
    print str(saved_count) + ' protein has been download'

    fp.write('\n\nnum_with_TF: ' + str(num_with_TF) + '\n')
    fp.write('num_with_Enzyme: ' + str(num_with_Enzyme) + 'compare: ' + str(len(gene_exist_list)) + '\n')
    fp.write('num of gene which product RNA: ' + str(num_with_RNA) +'\n')
    fp.write('num of gene with multi enzyme: ' + str(len(gene_multi_exit_list)) + '\n')
    fp.write('num found in uniprot: ' + str(num_not_found_in_uniprot) + '\n')
    fp.write('num of protein newly added: ' + str(saved_count))

    fp.close()
    fp_not_found.close()

main()
