# A mass cytometry workflow environment
FROM continuumio/miniconda3:23.3.1-0
# This created an image: 2023/06/30. Image needs to be tested


# TODO: start from different miniconda environment
# Try the following:
# FROM continuumio/miniconda3:23.3.1-0-alpine
# FROM continuumio/miniconda3:4.12.0

# FROM continuumio/miniconda3:22.11.1
# FROM continuumio/miniconda3:22.11.1-alpine

# TODO: do i need to create & activate an environment within container?


ENV CONDA_PREFIX /opt/conda

ARG TMPFILE=mytmp

RUN mkdir ${TMPFILE}

# RUN conda create -n myenv
# SHELL ["conda", "run", "-n", "myenv", "/bin/bash", "-c"]

RUN conda config --add channels defaults
RUN conda config --add channels anaconda
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge
# RUN conda config --set channel_priority strict

RUN conda config --show channels
RUN conda list

# RUN conda config --set restore_free_channel true
# RUN conda env create -f /${TMPFILE}/virtual_platform_mac.yml
# RUN conda config --env --set restore_free_channel true
RUN conda install conda=23.3.1
# RUN conda update conda=23.3.1
RUN conda update -y conda

RUN conda list

RUN conda install -c conda-forge r-essentials=4.2

RUN conda list

RUN conda install -c bioconda bioconductor-catalyst=1.22.0
RUN conda install -c bioconda bioconductor-diffcyt=1.18.0
RUN conda install -c bioconda bioconductor-ggcyto=1.26.0 
RUN conda install -c conda-forge r-devtools=2.4.5
RUN conda install -c bioconda bioconductor-sva=3.46.0
RUN conda install -c conda-forge r-outliers=0.15
RUN conda install -c conda-forge r-emdist=0.3_2
RUN conda install -c conda-forge r-biocmanager=1.30.21

RUN conda install -c conda-forge ca-certificates

RUN conda install -c conda-forge jupyterlab=4.0.2
RUN conda install -c conda-forge pandas=2.0.2
RUN conda install -c conda-forge scikit-learn=1.2.2
RUN conda install -c conda-forge numpy=1.25.0
RUN conda install -c conda-forge plotnine=0.12.1
RUN conda install -c conda-forge seaborn=0.12.2 
RUN conda install -c conda-forge openpyxl=3.1.2
RUN conda install -c conda-forge statsmodels=0.14.0 
RUN conda install -c conda-forge nbconvert=7.6.0

# Latest Catalyst version on bioconductor: 1.24.0
# Latest diffcyt version on bioconductor: 1.20.0
#3 UN R -e "BiocManager::install('CATALYST')"
# RUN R -e "BiocManager::install('diffcyt')"

RUN conda list


# COPY environment.yml /${TMPFILE}/environment.yml
# COPY scripts/install_environment.py /${TMPFILE}/install_environment.py

# RUN cd /${TMPFILE} && \
#    python /${TMPFILE}/install_environment.py > /${TMPFILE}/conda_install.sh && \
#    bash /${TMPFILE}/conda_install.sh


COPY . /source/cio-mass-cytometry

RUN cd /source/cio-mass-cytometry && pip install .

RUN mkdir /.local && \
    chmod 777 /.local

RUN mkdir /.jupyter && \
    chmod 777 /.jupyter


# WORKDIR /home
WORKDIR /immuno

##ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#ENTRYPOINT ["conda","run","--no-capture-output","-n",

RUN conda list

# Add Jupyter kernels?
RUN R -e "IRkernel::installspec(name='R_catalystDock', displayname='R_catalystDock')"
RUN python -m ipykernel install --user --name='py_catalystDock'
# CMD ["python", "-m", "ipykernel", "install", "--user", "--name='py_catalystDock'"]
# Add nbextensions (not all fucntionality works)
# RUN jupyter contrib nbextension install --sys-prefix
# CMD ["jupyter", "contrib", "nbextension", "install", "--sys-prefix"]
# RUN jupyter nbextension enable varInspector/main
# CMD ["jupyter", "nbextension", "enable", "varInspector/main"]

CMD ["jupyter","lab","--ip=0.0.0.0","--port=8427","--allow-root"]
