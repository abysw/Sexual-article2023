#!/bin/bash
# File Name: abysw.script.2023.sh
# Author  : fuyuan, Yuan-SW-F, yuanswf@163.com
# Created Time: 2023-06-02 12:36:48

#NGS reads filter
java -jar /abysw/git/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 /xulab/fuyuan/10.liveworts/survey/Ricciocarpus_natans/Ricciocarpus_natans_NGS/Ricciocarpus_natans_NGS.R1.fastq.gz /xulab/fuyuan/10.liveworts/survey/Ricciocarpus_natans/Ricciocarpus_natans_NGS/Ricciocarpus_natans_NGS.R1.fastq.gz Ricciocarpus_natans_NGS/Ricciocarpus_natans_NGS_1.clean.fq.gz Ricciocarpus_natans_NGS/Ricciocarpus_natans_NGS_1.unpaired.fq.gz Ricciocarpus_natans_NGS/Ricciocarpus_natans_NGS_2.clean.fq.gz Ricciocarpus_natans_NGS/Ricciocarpus_natans_NGS_2.unpaired.fq.gz ILLUMINACLIP:/abysw/git/Trimmomatic-0.39/adapters/BGIseq.fa:2:30:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:4:20 -threads 48 MINLEN:36 && echo FilterTaskFinished 

#LAI
ltr_finder -t 64 -D 20000 -d 1000 -L 700 -l 100 -p 20 -C -M 0.9 $i > $i.finder.scn
LTR_retriever -threads 64 -genome $i -infinder $i.finder.scn
LAI -t 64 -genome $i -intact $i.pass.list -all $i.out

#repeat annotation
EDTA.pl genome.fa
#gene annotation
maker -RM_off maker_opts.ctl maker_bopts.ctl maker_exe.ctl

gff3_merge -d chr9.maker.output/chr9_master_datastore_index.log
gff3_merge -d maker_index.log -o maker.all.gff3
gff3_merge -d maker_index.log -o maker.all.gff -g -n
gffread maker.all.gff -g genome.fa -x maker.all.gff.cds -y maker.all.gff.pep 

echo start training NOW!
maker2zff maker.all.gff3
echo waite a minute, please do NOT panic!
fathom genome.ann genome.dna -gene-stats > stats.log 2> stats.err
fathom genome.ann genome.dna -validate
fathom genome.ann genome.dna -categorize 1000
fathom uni.ann uni.dna -export 1000 -plus
mkdir params
cd params
forge ../export.ann ../export.dna
cd ..
hmm-assembler.pl all params > snap.hmm

#function annotation
export PATH=/abysw/soft/annotation/interproscan-5.56-89.0:$PATH;
interproscan.sh -i OG.fa -b OG.fa.iprscan -goterms -iprlookup -pa -dp -cpu 24

#syntenic blocks
python -m jcvi.graphics.karyotype seqids layout; mv karyotype.pdf Syn.Mapol.Riflu.rbh.karyotype.pdf

# Evolution and Phylogenetic analyses
muscle -align Mapol_MpVg00160.2.fa.all.fasta.m8.new.fasta -output Mapol_MpVg00160.2.fa.all.fasta.m8.new.fasta.muscle
#mafft --maxiterate 100 --thread 20 --localpair Mapol_MpVg00160.2.fa.all.fasta.m8.new.fasta > Mapol_MpVg00160.2.fa.all.fasta.m8.new.fasta.mafft
trimal -in Mapol_MpVg00160.2.fa.all.fasta.m8.new.fasta.muscle -out Mapol_MpVg00160.2.fa.all.fasta.m8.new.fasta.muscle.trimal -automated1
fasttree Mapol_MpVg00160.2.fa.all.fasta.m8.new.fasta.muscle.trimal > Mapol_MpVg00160.2.fa.all.fasta.m8.new.fasta.muscle.trimal.fast.tree
fa2phy Mapol_MpVg00160.2.fa.all.fasta.m8.new.fasta.muscle.trimal > Mapol_MpVg00160.2.fa.all.fasta.m8.new.fasta.muscle.trimal.phy
iqtree -s Mapol_MpVg00160.2.fa.all.fasta.m8.new.fasta.muscle.trimal.phy -m MFP -B 1000 --bnni -T AUTO
