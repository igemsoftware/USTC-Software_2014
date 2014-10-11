
fr = open('/Users/feiyicheng/Documents/igem-backend/origin_data/regulondb/collection/link/sRNA_Gene.txt', 'rU')
fw = open('/Users/feiyicheng/Documents/igem-backend/origin_data/regulondb/collection/link/new.txt', 'w')

line = fr.readline()
while line:
	newline = line[0].upper() + line[1:]
	fw.write(newline)
	line = fr.readline()
