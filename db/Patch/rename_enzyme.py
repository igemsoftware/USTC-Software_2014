__author__ = 'Beibeihome'

from pymongo import *
import CONSTANT
import bson

## 2014/8/28
## This Patch change attribute in kegg database that NAME to ENTRY, NAME_KEGG to NAME
## After Patch, Version = 1.1.1.0

db = MongoClient()[CONSTANT.DATABASE]
log_path = './log/rename_enzyme.txt'
enzyme_log = './log/edited_enzyme_log.txt'
multi_gene_log = open('./log/with_multigene_enzyme.txt', 'w+')


def base_name_to_uni(database_name):
    uni_name = database_name.replace('-', '').split('_')[0]
    return uni_name


def setLink(doc1, doc2, type1, type2):
    if not type1:
        type1 = doc1['TYPE']
    if not type2:
        type2 = doc2['TYPE']
    link_instance = {}
    #link_instance.ID = getID('link')
    link_instance['NODE1'] = bson.ObjectId(doc1['_id'])
    link_instance['NODE2'] = bson.ObjectId(doc2['_id'])
    link_instance['TYPE1'] = type1
    link_instance['TYPE2'] = type2
    link_id = db.link.insert(link_instance)
    del link_instance
    #print link_id
    db.node.update({'_id': doc1['_id']}, {'$push': {'EDGE': link_id}})
    db.node.update({'_id': doc2['_id']}, {'$push': {'EDGE': link_id}})


def separate(enzyme):
    origin_id = enzyme['_id']
    #print enzyme['ENTRY'] + ' is separating'
    # Get another node over the link and edit EDGE of another node
    another_node_list = []
    for edge_id in enzyme['EDGE']:
        link = db.link.find_one({'_id': edge_id})
        if enzyme['_id'] == link['NODE1']:
            another_node_list.append({'node': link['NODE2'], 'direct': 1})
            # edit another node EDGE, and delete this link later
            db.node.update({'_id': link['NODE2']}, {'$pop': {'EDGE': edge_id}})
        else:
            another_node_list.append({'node': link['NODE1'], 'direct': 0})
            db.node.update({'_id': link['NODE1']}, {'$pop': {'EDGE': edge_id}})

    # Create new node
    new_node_list = []
    #enzyme.pop('_id')
    for NAME in enzyme['NAME']:
        enzyme.pop('_id')
        ## ALERT: Insert function will change enzyme.
        id = db.node.insert(enzyme)
        db.node.update({'_id': id}, {'$set': {'NAME': NAME, 'EDGE': []}})
        new_node_list.append(id)

    # Create new link
    for new_node_id in new_node_list:
        new_node = db.node.find_one({'_id': new_node_id})
        for another_node in another_node_list:
            if another_node['direct'] == 1:
                node = db.node.find_one({'_id': another_node['node']})
                setLink(new_node, node, 'Enzyme', 'Reaction')
            elif another_node['direct'] == 0:
                another_name = db.node.find_one({'_id': another_node['node']})['NAME']
                #print 'Gene name: ' + another_name
                uni_node = db.uniprot.find_one({'gene_name': base_name_to_uni(another_name)})
                if uni_node is None:
                    #print 'This gene can\'t be found in uniprot'
                    continue
                #print 'this gene is in uniprot'
                protein_name = uni_node['protein_name']
                match_flat = (new_node['NAME'] == protein_name)
                if match_flat is False:
                    #print 'This gene is not match this enzyme'
                    continue
                #print 'this gene is link to this enzyme\n\n'
                node = db.node.find_one({'_id': another_node['node']})
                setLink(node, new_node, 'Gene', 'Enzyme')

    # Delete old node and link
    enzyme = db.node.find_one({'_id': origin_id})
    for edge in enzyme['EDGE']:
        db.link.remove({'_id': edge})
    db.node.remove({'_id': enzyme['_id']})

## 1 step: rename kegg data directly
db.node.update({'$or': [{'TYPE':'Compound'}, {'TYPE':'Enzyme'}]}, {'$rename': {'NAME': 'Identifier'}}, multi=True)
db.node.update({'TYPE': 'Compound'}, {'$rename': {'NAME_KEGG': 'NAME'}}, multi=True)
db.node.update({'TYPE': 'Enzyme'}, {'$set': {'NAME': []}}, multi=True)

## 2 step: establish gene:enzyme table
gene_exist_table = {}
multi_gene = []
for enzyme in db.node.find({'TYPE': 'Enzyme'}):
    for gene in enzyme['GENES']:
        if gene not in gene_exist_table.keys():
            gene_exist_table[gene] = [enzyme['_id'], ]
            #gene_exist_table[gene] = [enzyme['NAME'], ]
        else:
            gene_exist_table[gene].append(enzyme['_id'])
            #gene_exist_table[gene].append(enzyme['NAME'])
            multi_gene.append(gene)
print 'gene_exist_table has been built'

## 3 step: search uniprot reference table to find taget gene and edit its enzyme name
edited_count = 0
edited_id_list = []
for gene_name in gene_exist_table.keys():
    gene_name = gene_name.replace('-', '').split('_')[0]   #genename uniprotize
    gene_uniprot = db.uniprot.find_one({'gene_name': gene_name})
    if gene_uniprot is not None:
        protein_name = gene_uniprot['protein_name']
        for enzyme_id in gene_exist_table[gene_name]:
            # log enzyme id of enzyme edited
            if enzyme_id not in edited_id_list:
                edited_id_list.append(enzyme_id)
            #db.node.update({'_id': enzyme_id}, {'$set': {'NAME': protein_name}})
            db.node.update({'_id': enzyme_id}, {'$push': {'NAME': protein_name}})  # multi-name waiting to separate
            edited_count += 1

## 3.1step: manually rename enzyme
db.node.update({'Identifier': 'EC 3.5.1.2'}, {'$set': {'NAME': ['GlsA', 'GlsB']}})  # gene glsA\glsB
db.node.update({'Identifier': 'EC 2.1.1.223'}, {'$set': {'NAME': 'TrmN'}})   # gene trmN
# db.node.update({'NAME': 'trmN', 'TYPE': 'Gene'}, {'$push': {''}})
db.node.update({'Identifier': 'EC 1.2.1.19'}, {'$set': {'NAME': 'AdbH'}})   # gene patD
db.node.update({'Identifier': 'EC 3.5.3.26'}, {'$set': {'NAME': 'YlbA'}})    # gene allE

## 4 step: create log
fp_enzyme_edited = open(enzyme_log, 'w')
log_file = open(log_path, 'w')

log_file.write('with multi enzyme genes\n')
log_file.write(str(multi_gene) + '\n')

log_file.write('details\n')
log_file.write(str(gene_exist_table))

log_file.write('edited enzyme count: ' + str(edited_count) + '\n')
log_file.write('edited enzyme list: \n' + str(edited_id_list) + '\n')
fp_enzyme_edited.write(str(edited_id_list))

log_file.close()
fp_enzyme_edited.close()

## 5 step: separate EC node to several Enzyme node
multi_gene_log.write('Identifier\tGENES\tNAME\n')
for enzyme in db.node.find({'TYPE': 'Enzyme'}):
    # log create
    multi_gene_log.write(enzyme['Identifier'] + '\t' + str(enzyme['GENES']) + '\t' + str(enzyme['NAME']) + '\n')
    if len(enzyme['NAME']) > 1:
        separate(enzyme)
    # un-listize for Enzyme which only have one name but saved in list form
    else:
        db.node.update({'_id': enzyme['_id']}, {'$set': {'NAME': enzyme['NAME'][0]}})

## 6 step: create enzyme log which has not been edited
log_enzyme_unedited_path = './log/enzyme_unedited.txt'
fp_unedited = open(log_enzyme_unedited_path, 'w')

enzyme_dict = {}
for enzyme in db.node.find({'TYPE': 'Enzyme'}):
    if enzyme['_id'] not in edited_id_list:
        enzyme_dict[enzyme['Identifier']] = [enzyme['NAME'], enzyme['GENES']]

fp_unedited.write(str(enzyme_dict))
fp_unedited.close()


## 7 step: add sysname to sigma protein

db.node.update({'NAME': 'FecI'}, {'$push': {'SYSNAME': 'sigma19'}})
db.node.update({'NAME': 'RpoE'}, {'$push': {'SYSNAME': 'sigma24'}})
db.node.update({'NAME': 'FliA'}, {'$push': {'SYSNAME': 'sigma28'}})
db.node.update({'NAME': 'RpoH'}, {'$push': {'SYSNAME': 'sigma32'}})
db.node.update({'NAME': 'RpoS'}, {'$push': {'SYSNAME': 'sigma38'}})
db.node.update({'NAME': 'Rp54'}, {'$push': {'SYSNAME': 'sigma54'}})
db.node.update({'NAME': 'RpoD'}, {'$push': {'SYSNAME': 'sigma70'}})
