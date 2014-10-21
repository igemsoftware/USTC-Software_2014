__author__ = 'Beibeihome'

import os
import pymongo
import CONSTANT
from CONSTANT import db


def main():
    fp = './BLAST/sequence.fasta'
    file = open(fp, 'w')
    text_list = []
    text = ''

    for utr in db.u_t_r.find({'TYPE': 'O_T_P'}):
        id = str(utr['_id'])
        sequence_5 = utr['SEQUENCE_5']
        sequence_3 = utr['SEQUENCE_3']
        id = '>' + id + '\n'
        if sequence_5:
            text = ' '.join([id, sequence_5, '\n'])
            text_list.append(text)
        '''
        if sequence_3:
            text = ' '.join([id, sequence_3, '\n'])
            text_list.append(text)
        '''
    print 'Successfully read utr sequences'

    for node in db.node.find({'TYPE': {'$in': ['Promoter', 'Gene', 'Terminator']}}):
        if 'SEQUENCE' in node.keys():
            if node['SEQUENCE']:
                id = str(node['_id'])
                id = '>' + id + '\n'
                sequence = node['SEQUENCE']
                text = ' '.join([id, sequence, '\n'])
                text_list.append(text)
    print 'Successfully read node sequences'

    for text in text_list:
        file.write(text)
    print 'Successfully write sequences'

    file.close()

main()