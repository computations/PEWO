__author__ = "Ben Bettisworth"
__license__ = "MIT"

import os
import pewo.config as cfg
from pewo.templates import get_base_queryname_template, get_common_queryname_template
from pewo.software import DamageSoftware, AlignmentSoftware

_alignment_dir = get_software_dir(config, AlignmentSoftware.HMMER)
_damage_dir = get_software_dir(config, DamageSoftware.PYGARGAMMEL)
_work_dir = cfg.get_work_dir(config)

def _build_pygargammel_command():
    return ("pygargammel --align " +
                    "--max-fragments {params.min_fragments} " +
                    "--min-fragments {params.max_fragments} " +
                    "--min-length {params.min_fragment_length} " +
                    "--fasta {input.sequences} " +
                    "--nick-freq {wildcards.nick_freq} " +
                    "--overhang-parameter {wildcards.overhang} " +
                    "--double-strand-deamination {wildcards.double_strand} " +
                    "--single-strand-deamination {wildcards.single_strand} " +
                    "--output {output.damaged_sequences_filename} "+
                    "--log {log.logfile}")

rule damage_reads_post_alignment:
    input:
        sequences = os.path.join(_alignment_dir, "{pruning}", get_common_queryname_template(config) + ".fasta_queries")

    output:
        damaged_sequences_filename = os.path.join(_damage_dir, "{pruning}",
                                                  get_common_queryname_template(config)+
                                                  ".fasta")

    log:
        logfile = os.path.join(get_experiment_log_dir_template(config, DamageSoftware.PYGARGAMMEL),
                     get_common_queryname_template(config) + ".log")

    params:
        min_fragment_length = 
            config["config_pygargammel"]["min-fragment-length"],
        min_fragments= 
            config["config_pygargammel"]["min-fragments"],
        max_fragments= 
            config["config_pygargammel"]["max-fragments"],

    shell:
        _build_pygargammel_command()

rule damage_reads_pre_alignment:
    input:
        sequences = os.path.join(_work_dir, "R", get_base_queryname_template(config) + ".fasta")

    output:
        damaged_sequences_filename = os.path.join(_work_dir, "D", get_common_queryname_template(config)+ ".fasta")

    log:
        logfile = os.path.join(get_experiment_log_dir_template(config, DamageSoftware.PYGARGAMMEL),
                     get_common_queryname_template(config) + ".log")

    params:
        min_fragment_length = 
            config["config_pygargammel"]["min-fragment-length"],
        min_fragments= 
            config["config_pygargammel"]["min-fragments"],
        max_fragments= 
            config["config_pygargammel"]["max-fragments"],

    shell:
        _build_pygargammel_command()

rule damage_reads_no_alignment:
    input:
        sequences = os.path.join(_work_dir, "G", "{pruning}.fasta")

    output:
        damaged_sequences_filename = os.path.join(_damage_dir, "{pruning}",
                                                  get_common_queryname_template(config)+
                                                  ".noalign.fasta")

    log:
        logfile = os.path.join(get_experiment_log_dir_template(config, DamageSoftware.PYGARGAMMEL),
                     get_common_queryname_template(config) + ".log")

    params:
        min_fragment_length = 
            config["config_pygargammel"]["min-fragment-length"],
        min_fragments= 
            config["config_pygargammel"]["min-fragments"],
        max_fragments= 
            config["config_pygargammel"]["max-fragments"],

    shell:
        _build_pygargammel_command()
