import os
import pewo.config as cfg

_work_dir = cfg.get_work_dir(config)

rule compute_entropy:
    input:
        jplace = os.path.join(_work_dir, "{whatever}.jplace"),
    output:
        csv = os.path.join(_work_dir, "{whatever}_entropy.csv"),
    log: 
        os.path.join(_work_dir, "logs", "{whatever}.log")
    shell:
        "compute_entropy {input.jplace} --output {output.csv} &> {log}"
