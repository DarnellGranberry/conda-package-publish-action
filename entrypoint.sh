#!/bin/bash

set -ex
set -o pipefail

go_to_build_dir() {
    if [ ! -z "$INPUT_SUBDIR" ]; then
        cd "$INPUT_SUBDIR"
    fi
}

check_if_meta_yaml_file_exists() {
    if [ ! -f meta.yaml ]; then
        echo "meta.yaml must exist in the directory that is being packaged and published."
        exit 1
    fi
}

build_package(){
    conda build -c defaults -c conda-forge -c bioconda -c pytorch --output-folder build_output .
    #conda convert -p osx-64 build_output/linux-64/*.tar.bz2
}

upload_package(){
    export ANACONDA_API_TOKEN="$INPUT_ANACONDATOKEN"
    anaconda upload --label main build_output/noarch/*.tar.bz2 || echo "Upload failed for noarch"
    #anaconda upload --label main build_output/linux-64/*.tar.bz2
    #anaconda upload --label main build_output/osx-64/*.tar.bz2
}

go_to_build_dir
check_if_meta_yaml_file_exists
build_package
upload_package
