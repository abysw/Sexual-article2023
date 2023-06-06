#!/bin/bash
# File Name: run_enrich.sh
# Author  : sunwenjing, Yuan-SW-F, yuanswf@163.com
# Created Time: 2022-10-30 19:46:30

ann=$1
ref=$2
deg=$3
#source `abysw path`/../../abysw.cfg
EMCP_HOME=/chenlab/sunwenjing/16.Triplostegia/02.enrich/01.kegg_enrich_db/emcp2
#export PATH=

# step1, run eggnog-mapper
#python2 /pub/software/eggnog-mapper-1.0.3/emapper.py -m diamond  -i GDDH13_1-1_prot.fasta -o my --cpu 20

# step2, make orgDB
Rscript $EMCP_HOME/makeOrgPackageFromEmapper.R $ann

# step3, statictics
Rscript $EMCP_HOME/AnnoStat.R $ref

# enrichment
#Rscript $EMCP_HOME/enrich.R --de_result $deg --de_log2FoldChange 1 --de_padj 0.05

