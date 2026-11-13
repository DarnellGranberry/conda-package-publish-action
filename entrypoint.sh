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
    # conda-forge alone carries the build dependencies (including pytorch and torchvision); mixing in
    # defaults, bioconda and the retired pytorch channel made the dependency solve far more expensive
    conda build -c conda-forge --output-folder build_output .
}

upload_package(){
    export ANACONDA_API_TOKEN="$INPUT_ANACONDATOKEN"
    # conda-build writes .tar.bz2 or .conda depending on its version; a failed upload fails the job
    shopt -s nullglob
    packages=(build_output/noarch/*.tar.bz2 build_output/noarch/*.conda)
    if [ ${#packages[@]} -eq 0 ]; then
        echo "No noarch package was built in build_output/noarch."
        exit 1
    fi
    anaconda upload --label main "${packages[@]}"
}

go_to_build_dir
check_if_meta_yaml_file_exists
build_package
upload_package
