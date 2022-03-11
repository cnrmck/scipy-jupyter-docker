# the run scipy_notebook script will replace the SCIPYVERSION number before building
FROM jupyter/scipy-notebook:SCIPYVERSION

RUN conda install --quiet --yes --file scipy-requirements.txt