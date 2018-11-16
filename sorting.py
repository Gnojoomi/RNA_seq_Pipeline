#!/bin/python
#!/bin/python
import sys

file1=sys.argv[1] #names_strand_file
file2=sys.argv[2] #output.txt file
file3=sys.argv[3] #outputted output.txt to one with name changes
name_name=sys.argv[4] #PT_
file4=sys.argv[5] #outputted

fin=open(file1,"r")
lines=fin.readlines()
strand=[]
names=[]
for x in lines:
	names.append(x.split(':')[0])
        strand.append(x.split(':')[1])
fin.close()

fout_out=open(file3,"w")
with open(file2) as fout:
    counter=0
    for line in fout:
       # print (line[0], line[2], line[3])
        if (line[0]==">"):
		strand[counter] = strand[counter].replace("\n", "")
		names[counter] = names[counter].replace("\n", "")
		line1=">"+name_name+"::"+names[counter]+strand[counter]+'\n'
		counter=counter+1
                fout_out.write(line1)
        #if (line[0]=="M"):
         #       continue;
        #if (line[0]=="M"):
         #       continue
        #if (line[0]=="M" and line[3]=="u"):
         #       continue
        else:
                fout_out.write(line)
fout.close()
fout_out.close()
new_name=[]
new_sequence=[]
counter=0
with open(file3) as fin:
    for line in fin:
        if (line[0]==">" and counter==0):
                line = line.replace("\n","")
                new_name.append(line)
                sequence=""
        if (line[0]==">" and counter==1):
                new_sequence.append(sequence)
                sequence=""
                line = line.replace("\n","")
                new_name.append(line)
        if (line[0]!=">"):
                line = line.replace("\n", "")
                sequence+=line
                counter=1
new_sequence.append(sequence)
fin.close()

final_seq=[]
final_name=[]
seq_name=new_name[0]
final_sequence=new_sequence[0]
final_names=new_name[0]
#print (len(new_name))
for i in range(1,len(new_name)):
 #   print (i)
 #   print (new_sequence[i])
    if (seq_name==new_name[i]):
	final_sequence=final_sequence+new_sequence[i]
	seq_name=new_name[i]
#	print ("hello3")
    if (seq_name!=new_name[i]):
#	print ("hello4")
	if (final_sequence!=""):	
		final_seq.append(final_sequence)
		final_name.append(seq_name)
		final_sequence=new_sequence[i]
		seq_name=new_name[i]
#		print ("hello6")
final_seq.append(final_sequence)
final_name.append(seq_name)
#	print ("hello8")
#print(len(final_seq))
#print (final_name)

#print (len(new_name))
f_transcripts=open(file4,"w")
for q in range(0,len(final_name)):
	name1=final_name[q]+'\n'
	seq1=final_seq[q]+'\n'
	f_transcripts.write(name1)
	f_transcripts.write(seq1)
f_transcripts.close()


#print (len(new_name))
#dictionary = dict(zip(new_name, new_sequence))
#len(dictionary)
#print(len(dictionary))
#new_dictionary={''.join(values) for (key,value) in dictionary.items()}
