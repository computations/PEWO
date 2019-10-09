'''
module to operate placements with EPA (part of raxml)
note1: that raxml outputs many files, but only the jplace is kept
note2: raxml outputs results only in current working directory, so EPA dir needs to be explicitly set
note3: raxml may create a .reduced file in the directory of the input alignment, while this was initially
managed by using a temp() for the corresponding output, this output may or may not exists

@author Benjamin Linard
'''

# TODO: SSE3 version is used as default, there should be a way to test SSE3/AVX availability from python and launch correct version accordingly

import os

configfile: "config.yaml"

#debug
if (config["debug"]==1):
    print("epa: "+os.getcwd())

#rule all:
#    input: expand(config["workdir"]+"/EPA/{pruning}/g{gepa}/{pruning}_r{length}_g{gepa}_epa.jplace", pruning=range(0,config["pruning_count"],1), length=config["read_length"], gepa=config["config_epa"]["G"])


def select_model_for_epa():
    if config["phylo_params"]["model"]=="GTR+G":
        return "GTRGAMMA"
    if config["phylo_params"]["model"]=="JTT+G":
        return "PROTGAMMAJTT"
    if config["phylo_params"]["model"]=="WAG+G":
        return "PROTGAMMAWAG"
    if config["phylo_params"]["model"]=="LG+G":
        return "PROTGAMMALG"
    return "NA"

rule placement_epa:
    input:
        hmm=config["workdir"]+"/HMM/{pruning}_r{length}.fasta",
        t=config["workdir"]+"/T/{pruning}.tree"
    output:
        temp(config["workdir"]+"/EPA/{pruning}/g{gepa}/RAxML_classificationLikelihoodWeights.{pruning}_r{length}"),
        temp(config["workdir"]+"/EPA/{pruning}/g{gepa}/RAxML_classification.{pruning}_r{length}"),
        temp(config["workdir"]+"/EPA/{pruning}/g{gepa}/RAxML_entropy.{pruning}_r{length}"),
        temp(config["workdir"]+"/EPA/{pruning}/g{gepa}/RAxML_info.{pruning}_r{length}"),
        temp(config["workdir"]+"/EPA/{pruning}/g{gepa}/RAxML_labelledTree.{pruning}_r{length}"),
        temp(config["workdir"]+"/EPA/{pruning}/g{gepa}/RAxML_originalLabelledTree.{pruning}_r{length}"),
        config["workdir"]+"/EPA/{pruning}/g{gepa}/{pruning}_r{length}_g{gepa}_epa.jplace"
    log:
        config["workdir"]+"/logs/placement_epa/{pruning}_r{length}_g{gepa}.log"
    version: "1.0"
    params:
        m=select_model_for_epa(),
        c=config["phylo_params"]["categories"],
        #G=config["config_epa"]["G"],
        name="{pruning}_r{length}",
        raxmlname=config["workdir"]+"/EPA/{pruning}/g{gepa}/RAxML_portableTree.{pruning}_r{length}.jplace",
        outname=config["workdir"]+"/EPA/{pruning}/g{gepa}/{pruning}_r{length}_g{gepa}_epa.jplace",
        reduction=config["workdir"]+"/HMM/{pruning}_r{length}.fasta.reduced",
        outdir= os.path.join(config["workdir"],"EPA/{pruning}/g{gepa}"),
        maxp=config["maxplacements"],
        minlwr=config["minlwr"]
    shell:
        """
        raxmlHPC-SSE3 -f v --epa-keep-placements={params.maxp} --epa-prob-threshold={params.minlwr} -w {params.outdir} -G {wildcards.gepa} -m {params.m} -c {params.c} -n {params.name} -s {input.hmm} -t {input.t} &> {log}
        mv {params.raxmlname} {params.outname}
        rm -f {params.reduction}
        """