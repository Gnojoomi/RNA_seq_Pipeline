#!/bin/python
import sys

file1=sys.argv[1] #GTF file
file2=sys.argv[2] #Outputted transcript coordinates
file3=sys.argv[3] #Outputted names_strand.txt

fin=open(file1,"r")
lines=fin.readlines()
chrom=[]
start=[]
end=[]
strand=[]
names=[]
for x in lines:
        chrom.append(x.split('\t')[0])
        start.append(int(x.split('\t')[3]))
        end.append(int(x.split('\t')[4]))
	strand.append(x.split('\t')[6])
	col_8=x.split('\t')[8]
	name0=col_8.split()[1]
        name1=name0.split(";")[0]
	names.append(name1.replace('"',''))
fin.close()
fout=open(file2,"w")
for i in range(len(chrom)):
    line=str(chrom[i])+":"+str(start[i])+"-"+str(end[i])+'\n'  
    fout.write(line)
fout.close()
fnames=open(file3,"w")
for j in range(len(names)):
    line=str(names[j])+":"+str(strand[j])+'\n'
    fnames.write(line)
fnames.close()   
#print (names[1],names[200])
#print (strand[26],strand[27],strand[28]) 
