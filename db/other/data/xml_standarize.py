__author__ = 'Beibeihome'

import os

data_path = 'H:\IGEM\Database\local_backend\ustc_igem_database\other\data'

for filename in os.listdir(data_path):
    print 'Parsing ' + filename
    if not filename.endswith('xml'):
        continue
    filepath = os.path.join(data_path, filename)
    file = open(filepath, 'r+')

    bash = file.readlines()
    bash[1] = '<uniprot>\n'

    file = open(filepath, 'w+')
    file.writelines(bash)

    print filename + ' has been standarized'



