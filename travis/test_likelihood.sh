#!/bin/bash

err_report() {
    echo "Error on line $1"
}

trap 'err_report $LINENO' ERR

source "$CONDA_DIR/etc/profile.d/conda.sh"
conda activate PEWO

# Run the fast likelihood example
snakemake -p \
--snakefile eval_likelihood.smk \
--config workdir=`pwd`/travis/tests/2_travis/likelihood_test/run \
--configfile travis/tests/2_travis_likelihood_test/config.yaml

