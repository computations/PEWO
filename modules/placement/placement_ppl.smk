'''
module to operate placements with PPLACER
builds first a pplacer packe with taxtastic, then compute placement using the package

@author Benjamin Linard
'''

#configfile: "config.yaml"

import os

#debug
if (config["debug"]==1):
    print("ppl: "+os.getcwd())
#debug

#rule all:
#    input: expand(config["workdir"]+"/PPLACER/{pruning}_r{length}_ppl.jplace", pruning=range(0,config["pruning_count"],1), length=config["read_length"])

'''
build pplacer pkgs using taxtastic
'''
rule build_package:
    input:
        a=config["workdir"]+"/A/{pruning}.align",
        t=config["workdir"]+"/T/{pruning}_optimised.tree",
        s=config["workdir"]+"/T/{pruning}_optimised.info"
    output:
        directory(config["workdir"]+"/PPLACER/{pruning}_refpkg")
    log:
        config["workdir"]+"/logs/taxtastic/{pruning}.log"
    version: "1.00"
    params:
        dir=config["workdir"]+"/PPLACER/{pruning}_refpkg"
    shell:
        "taxit create -P {params.dir} -l locus -f {input.a} -t {input.t} -s {input.s} &> {log}"


'''
placement itself
note: pplacer option '--out-dir' is not functional, it writes the jplace in current directory
which required the addition of the explicit 'cd'
'''
rule placement_pplacer:
    input:
        a=config["workdir"]+"/HMM/{pruning}_r{length}.fasta",
        p=config["workdir"]+"/PPLACER/{pruning}_refpkg"
    output:
        config["workdir"]+"/PPLACER/{pruning}_r{length}_ppl.jplace"
    log:
        config["workdir"]+"/logs/placement_pplacer/{pruning}_r{length}.log"
    version: "1.00"
    params:
        o=config["workdir"]+"/PPLACER/{pruning}_r{length}_ppl.jplace",
    shell:
        """
        pplacer -o {params.o} --verbosity 2 -c {input.p} {input.a} &> {log} 
        """