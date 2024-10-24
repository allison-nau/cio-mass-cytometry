# cio-mass-cytometry

This pipeline helps streamline the workflow of CATALYST[^1].

[^1]: Nowicka M et al. "CyTOF workflow: differential discovery in high-throughput high-dimensional cytometry datasets." *F1000Res.* 2017 May 26;6:748. doi: 10.12688/f1000research.11622.3.

## Quickstart

Get the Docker image and start a JupyterLab server. The following is an example on Linux, running the JupyterLab server as yourself:

```bash
docker pull vacation/cio-mass-cytometry:latest
docker run --user $(id -u):$(id -g) \
  -v /your/working/directory:/your/working/directory \
  -w /your/working/directory \
  --rm -p 8888:8888 vacation/cio-mass-cytometry:latest
```

Look for the JupyterLab server address and paste it into your browser:

*Example (don't copy this, find the address in your terminal):* `http://127.0.0.1:8888/lab?token=404afbf16b8a48c6a40c860aad2ad494`

## Example

We'll describe and link each step in the analysis here:

Jupyter notebooks saved in `notebooks/` contain all the steps to work through a CyTOF project. To get started you can clone this repository, and copy the `notebooks/` folder into your working directory and work from there.

All steps assume you have a fully capable environment needed by this pipeline installed; using the Docker may be the easiest way to set up your environment. 

## Table of contents for detailed instructions, using an example dataset:
### [00 - Stage Example Data](/documentation/00_PreparingFCS.md)

Using python, this initial step copies the FCS files to a `data/` folder in your local environment, sets up the `WORKFLOW/` directory where files used and created will reside, and the `scripts/` directory where the R script used for ingesting the project metadata resides.

We used the `cytomulate` package[^2] to create a synthetic dataset with attributes similar to a 13-marker dataset from Levine et al. 2015[^3].

[^2]: Yang Y et al. "Cytomulate: accurate and efficient simulation of CyTOF data." *Genome Biol.* 2023 Nov 16;24(1):262. doi: 10.1186/s13059-023-03099-1.
[^3]: Levine JH et al. "Data-Driven Phenotypic Dissection of AML Reveals Progenitor-like Cells that Correlate with Prognosis." *Cell.* 2015 Jul 2;162(1):184-97. doi: 10.1016/j.cell.2015.05.047.

### [01 - Get Panel Details](/documentation/01_GetPanelDetails.md)

Using R, this step extracts information about the panel run from the FCS files and ensures that panel details are consistent across FCS files. This will be used to fill in the metadata accurately.

### [02 - Create metadata template](/documentation/02_CreateMetaDataTemplate.md)

We use a Python CLI created here to generate a new blank metadata template sheet and then add on the sample names and file paths programmatically.

### [03 Ingest filled-in metadata](/documentation/03_IngestFilledMetaData.md)

Take the completed metadata spreadsheet and ingest it using python, creating a validated JSON format of all the input data.

### [04 Run CATALYST Stage 1](/documentation/04_RunCATALYSTstage1.md)

Use the metadata JSON you created to run CATALYST for the first stage of the pipeline and over-clustering.

### [05 Generate Cluster template](/documentation/05_GenerateClusterTemplate.md)

Take the CATALYST outputs and produce a worksheet of unlabeled clusters and generate figures.

### [06 Ingest labeled clusters](/documentation/06_IngestLabeledClusters.md)

Using python, ingest the Excel spreadsheet with cluster labels and save it as a JSON.

### [07 Run CATALYST stage 2](/documentation/07_RunCATALYSTstage2.md)

Use the cluster label JSON and the previous run of CATALYST to run the rest of the CATALYST pipeline, now with known cell labels generating figures.  

### [08 Output Data](/documentation/08_OutputData.md)

Save primary per-cell data and cell-type frequency, cell-type expression, and pseudobulk expression data, using python. (This can also be done via R).

### [09 diffcyt](/documentation/09_diffcyt.md)

Use diffcyt[^4] to calculate preliminary statistics for any desired models. The example shown here is pre vs post, regardless of response, for each of the following: 
- **differential abundance** (cell population frequency)
- **differential state by cluster** for each functional marker (for each cell population) 
- **pseudobulk differenntial state** for each functional marker with all non-excluded clusters combined

[^4]: Weber LM et al. "diffcyt: Differential discovery in high-dimensional cytometry via high-resolution clustering." *Communications Biology*, 2019 May 14;2:183. doi: 10.1038/s42003-019-0415-5.

### [Description for how to use command line tools](/documentation/CLI_Description.md)