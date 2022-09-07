# A mass cytometry workflow environment
FROM continuumio/miniconda3:4.14.0
ENV CONDA_PREFIX /opt/conda

# RUN conda update -y conda

# RUN pip install --upgrade pip && \
#    pip install pyyaml
RUN pip install --upgrade pip 

COPY environment.yml /tmp/environment.yml
COPY scripts/install_environment.py /tmp/install_environment.py

RUN mkdir tmp

RUN cd /tmp && \
    python /tmp/install_environment.py > /tmp/conda_install.sh && \
    bash /tmp/conda_install.sh

RUN apt update && apt-get install -y libcairo2-dev
RUN conda install -c conda-forge r-cairo=1.6_0

RUN R -e "install.packages('Cairo',dependencies=TRUE, repos='http://cran.rstudio.com/')"

RUN mkdir /.local && \
    chmod 777 /.local

RUN mkdir /.jupyter && \
    chmod 777 /.jupyter


WORKDIR /home

##ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#ENTRYPOINT ["conda","run","--no-capture-output","-n",

# Add Jupyter kernels?
# RUN R -e "IRkernel::installspec(name='R_catalystDock', displayname='R_catalystDock')"
# RUN python -m ipykernel install --user --name='py_catalystDock'

CMD ["jupyter","lab","--ip=0.0.0.0","--port=8888","--allow-root"]
