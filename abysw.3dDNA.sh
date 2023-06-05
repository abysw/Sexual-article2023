#!/bin/bash
# File Name: 3dDNA.sh
# Author  : fuyuan, Yuan-SW-F, yuanswf@163.com
# Created Time: 2022-01-17 14:57:46
#source /abyss/abyss.cfg

#####################################################################
echo preparing database at `date +%Y-%m-%d`
mkdir references
cd references
ln -s ../*fa genome.fa
bwa index genome.fa
python /abyss/git/juicer/misc/generate_site_positions.py MboI genome genome.fa
awk 'BEGIN{OFS="\t"}{print $1, $NF}' genome_MboI.txt > genome.chrom.size
echo preparing restriction_sites at `date +%Y-%m-%d`
mkdir ../restriction_sites
cp genome_MboI.txt genome.chrom.size ../restriction_sites
cd ..
ln -s /abyss/git/juicer/scripts
######################################################################
echo preparing job data at `date +%Y-%m-%d`
mkdir work2
cd work2
mkdir fastq
cd fastq
cp ../../*gz .
cd ..
######################################################################
echo running step1 at `date +%Y-%m-%d` in $PWD
sh /abyss/git/juicer/scripts/juicer.sh -g genome -s MboI -z ../references/genome.fa -p ../restriction_sites/genome.chrom.size -y ../restriction_sites/genome_MboI.txt -D /abyss/git/juicer -t 64 --qc
echo preparing to run step2 at `date +%Y-%m-%d`
mkdir asm
cd asm
samtools view -O SAM -F 1024 ../aligned/merged_dedup.bam | awk -v mnd=1 -f /abyss/git/juicer/scripts/common/sam_to_pre.awk >  merged_nodups.txt
#####################################################################
echo running step2 at `date +%Y-%m-%d` in $PWD
sh /xulab/pipeline/git/3d-dna/run-asm-pipeline.sh -r 0 ../../references/genome.fa merged_nodups.txt
mkdir ../asm1
cp merged_nodups.txt ../asm1
cd ../asm1
sh /xulab/pipeline/git/3d-dna/run-asm-pipeline.sh -r 1 ../../references/genome.fa merged_nodups.txt
mkdir ../asm2
cp merged_nodups.txt ../asm2
cd ../asm2
sh /xulab/pipeline/git/3d-dna/run-asm-pipeline.sh -r 2 ../../references/genome.fa merged_nodups.txt
echo all jobs were finished at `date +%Y-%m-%d`
echo you can find the resule in $PWD
#####################################################################
