__author__ = 'Beibeihome'
from mongoengine import *
from Modules.kegg_parse import node
import re
import pymongo
import CONSTANT


class count(Document):
    type = StringField()
    value = IntField()


class Gene_Enzyme_link(Document):
    ID = IntField()
    #NODE1 is Gene
    NODE1 = ReferenceField(node)
    #NODE2 is Enzyme
    NODE2 = ReferenceField(node)
    TYPE1 = StringField(default='Gene')
    TYPE2 = StringField(default='Enzyme')

    meta = {
        'collection': 'link'
    }


def main():
    connect('igemdata_new', host='mongodb://product:bXYtvBHrSdbuTMETSVO4VTWGl0oeddBHp3hPNsUbEZOEpRFLcqgaYAjHRirnSI@us-ce-0:27017,cn-ah-0:27017,cn-bj-0:27017', replicaSet='replset')
    enzyme_list = node.objects.filter(TYPE='Enzyme')
    count_saved = 0
    count_searched = 0
    for enzyme in enzyme_list:
        #print enzyme.GENES
        if enzyme.GENES:
            gene_list = node.objects.filter(TYPE='Gene')
            #print gene_list
            gene_list = gene_list.filter(NAME__in=enzyme.GENES)
            if gene_list:
                for gene in gene_list:
                    gene_enzyme_link = Gene_Enzyme_link()

                    gene_enzyme_link.NODE1 = gene
                    gene_enzyme_link.NODE2 = enzyme
                    gene_enzyme_link.save()
                    #Node set index to link
                    gene['EDGE'].append(gene_enzyme_link.id)
                    enzyme['EDGE'].append(gene_enzyme_link.id)
                    gene.save()
                    enzyme.save()

                    count_saved += 1
                #print str(count_saved) + ' link between gene and enzyme have been saved successfully'
        count_searched += 1
    print str(count_searched) + ' enzymes have been searched'


main()




