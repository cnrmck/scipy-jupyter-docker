# the run scipy_notebook script will replace the SCIPYVERSION number before building
FROM jupyter/scipy-notebook:SCIPYVERSION

USER root

# Provide password-less sudo to NB_USER
RUN \
    sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' && \
    echo "${NB_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \  
    chmod g+w /etc/passwd

USER $NB_UID
  
# all of these are used in the pygraphviz package which is required for dot files in dowhy
RUN DEBIAN_FRONTEND=noninteractive sudo apt-get update && \
    sudo apt-get install --yes gcc graphviz libgraphviz-dev pkg-config python3-pip
    
# python-graphviz and pydot are used with causalgraphicalmodels package
RUN conda install -y \
    python-graphviz==0.16 \
    pydot==1.4.2
    # tensorflow-deps==2.5.0

RUN pip3 install \
    plotly==4.10.0 \
    cufflinks==0.17.3 \
    networkx==2.5 \
    dowhy==0.4 \
    # torch==1.7.1 \
    # torchvision==0.8.2 \
    pygraphviz==1.7 \
    causalgraphicalmodels==0.0.4 \
    tensorflow==2.6.0 -f https://tf.kmtea.eu/whl/stable.html \
    # tensorflow==2.8.0 \
    keras==2.6.0 \
    wandb==0.12.11