# A mass cytometry workflow environment
FROM continuumio/miniconda3:4.12.0
# FROM continuumio/miniconda3:4.14.0
ENV CONDA_PREFIX /opt/conda

RUN conda update -y conda

# ARG USERNAME=dockuser1
# ARG USER_UID=1000
# ARG USER_GID=$USER_UID
ARG TMPFILE=tmp20221027

# RUN groupadd --gid ${USER_GID} ${USERNAME} \
#     && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} 

RUN mkdir ${TMPFILE}
# RUN chown ${USERNAME} ${TMPFILE}

# USER ${USERNAME}
# WORKDIR /home/${USERNAME}

# RUN pip install --upgrade pip && \
#    pip install pyyaml
RUN pip install --root-user-action=ignore --upgrade pip 
RUN pip install --root-user-action=ignore pyyaml==6.0

RUN conda install -c conda-forge ca-certificates

COPY environment.yml /${TMPFILE}/environment.yml
COPY scripts/install_environment.py /${TMPFILE}/install_environment.py

RUN cd /${TMPFILE} && \
    python /${TMPFILE}/install_environment.py > /${TMPFILE}/conda_install.sh && \
    bash /${TMPFILE}/conda_install.sh

RUN apt update && apt-get install -y libcairo2-dev
RUN conda install -c conda-forge r-cairo=1.6_0
RUN R -e "install.packages('Cairo',dependencies=TRUE, repos='http://cran.rstudio.com/')"

COPY . /source/cio-mass-cytometry

RUN cd /source/cio-mass-cytometry && pip install .

RUN mkdir /.local && \
    chmod 777 /.local

RUN mkdir /.jupyter && \
    chmod 777 /.jupyter


WORKDIR /home
# WORKDIR /immuno

##ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#ENTRYPOINT ["conda","run","--no-capture-output","-n",

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
# CMD ["jupyter","notebook","--ip=0.0.0.0","--port=8427","--allow-root"]
