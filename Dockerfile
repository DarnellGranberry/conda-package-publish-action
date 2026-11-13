# conda 24.x uses the libmamba solver by default. The 2019 image used before (4.7.10) ran out of
# memory solving against today's channels.
FROM continuumio/miniconda3:24.7.1-0

LABEL "repository"="https://github.com/darnellgranberry/conda-package-publish-action"
LABEL "maintainer"="Darnell Granberry"

RUN conda install -y -c conda-forge anaconda-client "conda-build=24.11.*" && conda clean -afy

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
