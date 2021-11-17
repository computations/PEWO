# PEWO demo n°5

## Overview

This demo measures CPU/RAM/TIME resources consumed by the different
placement softwares, using a reference dataset of 16S-rRNA barcodes.

EPA-ng, PPlacer, RAPPAS are tested.
Each measure is repeated 2 times.
This analysis will require around 3 hours of computation.

Final measures are reported as the mean of the repeats.
Consequently, increasing repeats would produce better evaluations.

## How to launch

Download pipeline.
```
git clone --recursive https://github.com/phylo42/PEWO.git
cd PEWO
```

Execute installation script.
```
chmod u+x INSTALL.sh
./INSTALL.sh
```

After installation, load environement.
```
conda activate PEWO
```

Test workflow before launch.
```
snakemake -np \
--snakefile eval_resources.smk \
--config workdir=$(pwd)/examples/5_CPU_RAM_requirements_evaluation/run \
query_user=`pwd`/examples/5_CPU_RAM_requirements_evaluation/EMP_92_studies_100000.fas \
--configfile examples/5_CPU_RAM_requirements_evaluation/config.yaml
```

Execute workflow, using 2 CPU cores and 16Gb of RAM.
```
snakemake -p --cores 2 --resources mem_mb=16000 \
--snakefile eval_resources.smk \
--config workdir=$(pwd)/examples/5_CPU_RAM_requirements_evaluation/run \
query_user=`pwd`/examples/5_CPU_RAM_requirements_evaluation/EMP_92_studies_100000.fas \
--configfile examples/5_CPU_RAM_requirements_evaluation/config.yaml
```

## Comments

In this example, 'workdir' and 'query_user' config flags are set
dynamically, as it is required they are passed as absolute paths.
You could also set them manually by editing the config.yaml file
before launch.

Raw results will be written in
'examples/5_CPU_RAM_requirements_evaluation/run/benchmark'.

Results summaries and plots will be written in
'examples/5_CPU_RAM_requirements_evaluation/run'.

See PEWO wiki for a more detailed explanation of the results:
https://github.com/phylo42/PEWO/wiki/IV.-Tutorials-and-results-interpretation
