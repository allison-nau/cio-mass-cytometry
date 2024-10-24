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

### [notebooks/00 - Python - Stage example data.ipynb](https://github.com/jason-weirather/cio-mass-cytometry/blob/main/notebooks/00%20-%20Python%20-%20Stage%20example%20data.ipynb)

This initial step copies the FCS files to a `data/` folder in your local environment, sets up the `WORKFLOW/` directory where files used and created will reside, and the `scripts/` directory where the R script used for ingesting the project metadata resides.

We used the `cytomulate` package[^2] to create a synthetic dataset with attributes similar to a 13-marker dataset from Levine et al. 2015[^3].

[^2]: Yang Y et al. "Cytomulate: accurate and efficient simulation of CyTOF data." *Genome Biol.* 2023 Nov 16;24(1):262. doi: 10.1186/s13059-023-03099-1.
[^3]: Levine JH et al. "Data-Driven Phenotypic Dissection of AML Reveals Progenitor-like Cells that Correlate with Prognosis." *Cell.* 2015 Jul 2;162(1):184-97. doi: 10.1016/j.cell.2015.05.047.

We generated 10 samples, with half of those samples being tampered with to reduce the amount of naive CD8+ T cells by 75%; this was to simulate an increase in T cells from a pre-treatment to post-treatment condition. These samples are saved in `cio_mass_cytometry/data` and should be included with the Python package. This folder also contains a fully completed metadata example suitable for ingesting and running the pipeline, and a fully labeled clustering spreadsheet example, suitable for running our final stages of the pipeline.

This gives us a simulated cohort with:

1. A 13-marker panel
2. 10 samples
3. 5 patients
4. Pre/Post timepoints
5. An expected increase in naive CD8+ T cells

**Pre-requisites:** Nothing is required.

**Post:** Creates 3 directories:

- `data/`: Contains FCS files `*.fcs`.
- `WORKFLOW/`: Will be used to save all files, figures, and data from the run. Divided into `stage_1/` with QC and over-clustering (unlabeled) used to make the clustering worksheet, `stage_2/` where we use the completed annotated clustering worksheet to finish the feature extraction, and `stage_2_models/` where preliminary statistical models will be stored. Contains a pre-made metadata template (`stage_1/03-INPUT-metadata-completed.xlsx`) you can use as a reference or directly, and a pre-made labeled clustering (`stage_2/06-INPUT-stage2-annotated-clusters-50.xlsx`) you can use as a reference or directly. Note that the pre-made labeled clustering may be subject to stochastic changes in other environments, so you should review and fill in your clustering worksheet accordingly.
- `scripts/`: Copy of our helper script `readDataset.R` for CATALYST to where it's easy to get to.

### [notebooks/01 - R - Get Panel details.ipynb](https://github.com/jason-weirather/cio-mass-cytometry/blob/main/notebooks/01%20-%20R%20-%20Get%20Panel%20details.ipynb)

This step extracts information about the panel run from the FCS files and ensures that panel details are consistent across FCS files. This will be used to fill in the metadata accurately.

**Pre-requisites:** Requires the FCS files.

**Post:** Extracts the header table from one of the FCS files.

👁️ **Review required:** You need to check that all FCS files are defined by this same table by checking that their hashes are all identical.
  
Note: if you discover that the naming of your fcs file parameters is inconsistent across fcs files (e.g. PD1 vs PD-1), you can use a lool like [ParkerICI/premessa::paneleditor_GUI()](https://github.com/ParkerICI/premessa) to assist in harmonizing your fcs files.

### [notebooks/02 - Python - Create metadata template.ipynb](https://github.com/jason-weirather/cio-mass-cytometry/blob/main/notebooks/02%20-%20Python%20-%20Create%20metadata%20template.ipynb)

We use a Python CLI created here to generate a new blank metadata template sheet and then add on the sample names and file paths programmatically.

**Pre-requisites:** Nothing is required.

**Post:** Creates `WORKFLOW/stage_1/02-metadata-template.xlsx`.

**Modifies:** After creating the metadata template (blank), it is filled in with sample names and file paths.

### *Not shown in notebook:* Accurately complete the metadata spreadsheet

You may need to delete some headers if you don't have the information on sample annotations or add additional headers if you have more that are not included here. As described in `cio_mass_cytometry/schemas/samples.json`, the permitted annotation types are `["discrete", "timepoint", "batch", "arm", "subject"]`. If you don't know what to call something, use `discrete`.  
  
**Pre-requisites:** You start with a blank or partially filled in template `WORKFLOW/stage_1/02-metadata-template.xlsx`.  
  
**Post:** You upload your filled-in `WORKFLOW/stage_1/03-INPUT-metadata-completed.xlsx` or use the one that was placed there as an example.  
  
### Filling out the WORKFLOW/stage_1/03-INPUT-metadata-completed.xlsx workbook:  

**Sheet Panel Parameters**:  
- Include information on the panel used  

**Sheet Panel Definition**:  
- Starting from the information included in "WORKFLOW/stage_1/01-panel-markers.csv", describe the panel used  
- All channels to be available to CATALYST should be listed. Markers to be clustered on (lineage markers, phenotype) should have their "Marker Classification" set to "type". Markers to be used as functional markers should have their "Marker Classifcation" set to "state". Markers that you would like available to some plots, but do not want to treat as either phenotype or functional markers can have their "Marker Classification" set to "none" (e.g. if you have pre-gated on CD45+, you wouldn't want to cluster on that marker, but you still may want it included in QC plots). It is not currently possible to use a marker both as a phenotype and as a functional marker.  

**Sheet Sample Manifest**:  
- All meta data describing each fcs file should be here  
- There must be a column for "Sample Name" and "Sample Display Name". Note that some plots will use the "Sample Name" as the "Sample Display Name".  
- Column "Include (default TRUE)" can be left blank if all files are included.   
  - Note: any staining controls should be included in the clustering. They can be removed later before performing any statisitcal test.  
    - Technical replicates can be used to check for batch effects, both by looking at the staining distribution for every channel, but also for the abundance of every cell population.  
- Column "FCS file" should have the relative path to each FCS File.  
- If you later want to change your metadata, adjusting the order the samples appear in the worksheet will have a similar effect as changing the random seed, so if you have already clustered once and are just redoing things to change the meta data, consider keeping the order the "FCS File"s appear in the notebook the same.  
- Any additional meta data should be added as columns to this sheet. (e.g. Timepoint, Cohort, Response, Patient_ID). If you have multiple timepoints for the same patient, you must include a column each for both Timepoint and Patient ID information.  

**Sheet Sample Annotations**  
- Meta data factor order should be specified in sheet for most "Sample Manifest" columns, including Timepoint, Cohort, Response, and Patient ID information. (e.g. Desired timepoint order label "Pre" is Numeric Order "0", while label "Post" is Numeric Order "1"). This is required in order to be able to have information in your plots appear in a logical order.  

**Sheet Meta**  
- Include the pipeline version here.  


### [notebooks/03 - Python - Ingest the filled-in metadata.ipynb](https://github.com/jason-weirather/cio-mass-cytometry/blob/main/notebooks/03%20-%20Python%20-%20Ingest%20the%20filled-in%20metadata.ipynb)

Take the completed metadata spreadsheet and ingest it, creating a validated JSON format of all the input data.

**Pre-requisites:** Requires your filled-in template describing your project `WORKFLOW/stage_1/03-INPUT-metadata-completed.xlsx`.

**Post:** You get a JSON format representation of your template in `WORKFLOW/stage_1/04-metadata-completed.json`.  

### [notebooks/04 - R - Run CATALYST stage 1.ipynb](https://github.com/jason-weirather/cio-mass-cytometry/blob/main/notebooks/04%20-%20R%20-%20Run%20CATALYST%20stage%201.ipynb)

Use the metadata JSON you created to run CATALYST for the first stage of the pipeline and over-clustering.

**Pre-requisites:** Requires your accurately filled-in and JSON-converted metadata `WORKFLOW/stage_1/04-metadata-completed.json`, and needs the `scripts/readDataset.R` helper script to automate the ingestion.

**Post:** There are many figures and data generated here. Figures will be discussed in the review notes, and there are several intermediate data files generated.

👁️ **Review required:** There are many things to check here.

- **Plot quality:** You may need to adjust parameters across any plots to get formatting how you like it.
- **Cell counts plot:** Does it indicate that some samples should be outright dropped? If yes, they can be dropped by flagging them in the metadata spreadsheet.
- **MDS plots:** The dimensional reduction should be inspected for any strong outlier samples that may have issues that need follow-up in FlowJo or more manual inspections. It should also be used to understand if any batch effects are prominent in the dataset because strong batch effects may interfere with clustering efficacy. In the example data, a strong difference is seen with `Timepoint` due to our simulated biological effect.
- **NRS plots:** These can help inform what is driving the signal in the MDS plots. Here, you can see the injected signal from CD8+ T cells pushing differences in the MDS.
- **Pseudobulk plot:** It may help to inform if some particular marker has aberrant expression on a particular sample.
- **FlowSOM clustering:** The most important question to ask is if the clustering count is high enough to capture all the cell populations you are interested in labeling. 
  - If you try to set the clustering of FlowSOM too low, then distinct populations could be combined together erroneously. If you do not see all the populations you would like identified, or the type marker plot shows mixed clusters, you may need to increase the number of clusters you are generating (e.g. 14x14 SOM grid for 50 clusters).
  - If you have batch effects present, this can be exacerbated because you may need different clusters for each batch. If you see batches in the MDS, and you see batches here, and you see batches in the upcoming UMAP, it may be time to stop and treat your batches as separate analysis projects for cell-type assignment. 
  - Sometimes changing the random seed will affect how well a minor population separates out. 
  - The list of markers to be clustered on should also be carefully considered. Markers with QC issues (no clear separation between positive and negative or major spill over from another channel) may need to be excluded. CATALYST currently clusters all markers at equal weight, which means panels that are heavily focused in one lineage may struggle to separate major lineages from each other. For example, if you have a long list of markers that separate out T cell sub-populations, but only one myeloid marker, you may see mixed populations that you would never see if you were manually gating. First try increasing the number of clusters. If that does not work, consider also reducing the number of markers to be clustered on in an over-represented lineage or increasing the number of markers in a lineage that is under-represented. If this issue cannot be solved by tweaking the markers you are clustering on and increasing the number of clusters, you may need to switch to a clustering method that allows you to weigh markers OR switch to a multi-stage clustering, where in the first round you would separate your major lineages from each other, and in the second round you would separate out your sub-populations.
- **Type marker plot:** This is a great plot, but if you have an enormous amount of samples, you may need to downsample your SSE in preparation for this figure. This plot can be a useful reference when you are labeling your clusters because you can understand, for both phenotypic and functional markers, if their distribution indicates a cluster is a particular cell type. It could also help you see if you may have erroneously combined some populations. If there are clusters that are mixed populations, you may need to adjust the number of clusters or adjust the markers used for clustering.
- **UMAP by `cluster_id`:** The clusters should look clustered on the UMAP.
- **UMAP expression plots:** This is important to look at to see if you have expected cell populations clustered into single clusters. If you see cell populations consistently showing up in two clusters, this could indicate that either (a) you have erroneously passed in a barcoding marker as a cell typing marker (happens with CD45 sometimes), or (b) you have a batch effect, and it's time to analyze that batch separately for cell-type assignment (or execute some batch effect correcting method out of scope here).
- **Multi-heatmap:** See cluster expression in samples to help understand any oddball samples.

### [notebooks/05 - Python - Generate cluster template.ipynb](https://github.com/jason-weirather/cio-mass-cytometry/blob/main/notebooks/05%20-%20Python%20-%20Generate%20cluster%20template.ipynb)

Take the CATALYST outputs and produce a worksheet of unlabeled clusters and generate figures.

**Pre-requisites:** Uses the metadata converted JSON `WORKFLOW/stage_1/04-metadata-completed.json`, and the four `WORKFLOW/stage_1/Intermediate_*` files from the previous step.

**Post:** Creates a worksheet template for labeling clusters in `WORKFLOW/stage_1/05-stage1-unannotated-clusters-50.xlsx`.

### *Not shown in notebook:* Accurately annotate all clusters in the over-clustered Excel sheet

You download the worksheet and you can use it in conjunction with the stage_1 CATALYST workflow to fill in which cell population each cluster represents. Take notice of the percentage of cellularity of each population because there may be some very small populations that are not easily classified but may be better to just set to an unknown or other label.

**Pre-requisites:** Take the unlabeled worksheet `WORKFLOW/stage_1/05-stage1-unannotated-clusters-50.xlsx`.

**Post:** The saved labeled worksheet `WORKFLOW/stage_2/06-INPUT-stage2-annotated-clusters-50.xlsx`; note this marks our switch from stage 1 of the workflow to stage 2.

👁️ **Review required:** We recommend working with an immunologist to complete this section.

### [notebooks/06 - Python - Ingest labeled clusters.ipynb](https://github.com/jason-weirather/cio-mass-cytometry/blob/main/notebooks/06%20-%20Python%20-%20Ingest%20labeled%20clusters.ipynb)

Ingest the Excel spreadsheet with cluster labels and save it as a JSON.

**Pre-requisites:** The labeled worksheet `WORKFLOW/stage_2/06-INPUT-stage2-annotated-clusters-50.xlsx`.

**Post:** Is converted to a JSON representation for easy ingestion in R `WORKFLOW/stage_2/07-cluster_id_conversion.json`.

### [notebooks/07 - R - Run CATALYST stage 2.ipynb](https://github.com/jason-weirather/cio-mass-cytometry/blob/main/notebooks/07%20-%20R%20-%20Run%20CATALYST%20stage%202.ipynb)

Use the cluster label JSON and the previous run of CATALYST to run the rest of the CATALYST pipeline, now with known cell labels generating figures.  
  
If there are clusters that you would like to remove (suspected non-cells, doublets), it is done so here. It is not recommended to remove populations that are merely not of interest, only populations that are not live singlet leukocytes.
  
**Pre-requisites:** Requires the intermediate RDS file and UMAP embeddings, as well as the JSON-converted labels.
  
**Post:** More final figures and data exports. Exports SSE object with NA_exclude clusters removed: `WORKFLOW/stage_2/Intermediate_07_sce-frame.RDS`.
  
👁️ **Review required:** There are many figures to inspect, and all may require some adjustments to properly format the image. cell_order that is used to specify cluster order in figures should be adjusted. It should also be checked that only the correct clusters are removed, or that step should be completely skipped.
  
- **UMAP clusters:** The cell-type labeled UMAP should have cell types well clustered.
- **Heatmap with FlowSOM labels:** This is not particularly great, but it shows both the FlowSOM and cell type labels. This plot can be used to confirm that the correct clusters are being merged together.
- **Heatmap labeled:** This is an excellent plot for verifying the cell type markers are where expected.
- **Heatmap all markers labeled:** Even better, this has the functional markers too.
- **Stacked bar plots:** You may need to modify the workflow to generate more of these, because if you have things like Arm and Response, it will probably be necessary to plot these for each of those.
- **Median expression plots:** These are useful for seeing what the expression of functional markers are on each cell type.

### [notebooks/08 - Python - Output data.ipynb](https://github.com/jason-weirather/cio-mass-cytometry/blob/main/notebooks/08%20-%20Python%20-%20Output%20data.ipynb)
  
Save primary per-cell data and cell-type frequency, cell-type expression, and pseudobulk expression data.
  
**Pre-requisites:** Requires the intermediate files from both `stage_1` and `stage_2`, as well as our completed metadata.
  
**Post:** Some primary data outputs suitable for further analysis:
  
- `WORKFLOW/stage_2/Data_01_cellular_data.parquet`: A one-cell-per-row file with the cluster label of each cell, metadata labels, calculated UMAP embedding, and the expression of each marker (arcsinh transformed).
- `WORKFLOW/stage_2/Data_02_cell_type_percent.csv`: For each sample, the percentage of each cell type present.
- `WORKFLOW/stage_2/Data_03_cell_type_expression_mean_median.csv`: For each cell type in each sample, the mean and median expressions of each marker.
- `WORKFLOW/stage_2/Data_04_pseudobulk_expression_mean_median.csv`: For each sample, the pseudobulk mean and median expression of each marker.

### [notebooks/09 - R - Pre vs Post statisitcs.ipynb](https://github.com/allison-nau/cio-mass-cytometry/blob/e3cf4660abc4b87f57b6ee7c58f68ee4530209ce/notebooks/09%20-%20R%20-%20Pre%20vs%20Post%20statisitcs.ipynb)
### [notebooks/09 - R - Pre vs Post statisitcs.ipynb](TODO: Add Link for jason's github)  

Use diffcyt[^4] to calculate preliminary statistics for any desired models. The example shown here is pre vs post, regardless of response, for each of the following: 
- **differential abundance** (cell population frequency)
- **differential state by cluster** for each functional marker (for each cell population) 
- **pseudobulk differenntial state** for each functional marker with all non-excluded clusters combined
  
Note: multiple hypothesis correction is done across each inidividual model (i.e. each time diffcyt is run), not across all models run.   

[^4]: Weber LM et al. "diffcyt: Differential discovery in high-dimensional cytometry via high-resolution clustering." *Communications Biology*, 2019 May 14;2:183. doi: 10.1038/s42003-019-0415-5.

**Pre-requisites:** Requires the intermediate files from `stage_2` including the SSE object from notebook 07 `WORKFLOW/stage_2/Intermediate_07_sce-frame.RDS`.  
  
**Post:** Preliminary statistics for any models included in the notebook, as well as some additional figures.
  
- All differential abundance models are combined into one csv, `WORKFLOW/stage_2_models/results_abundance_allmodels.csv`.  
- All differential state models for cell populations are stored in `WORKFLOW/stage_2_models/results_state_clusters_allmodels.csv`.   
- All differential state models for pseudobulk are stored in `WORKFLOW/stage_2_models/results_state_bulk_allmodels.csv`. 
- `WORKFLOW/stage_2_models/results_allmodels.xlsx` combines the previous 3 csv files into a multi-sheet excel file.

For differential abundance we are using the method "diffcyt-DA-edgeR". For differential state of functional markers across cell populations, we are using "diffcyt-DS-limma".
  
For each model, a sub output directory should be specified to store that models results, as well as a nickname for the model to be used when combining the results into one summary file. The SSE object should be filtered on to only include the samples included in that model, stored in `sub`. (e.g. If you are comparing responders to non-responders pre treatment, you would filter on that specific timepoint). We then need to grab the relevant metadata information and store it in dataframe `subex`. We then set up a design and contrast matrix, checking that the sample_id order lines up with the `subex` for that model. The variables that we want to be part of the model should be specified using the function `createDesignMatrix`. The variable we are interested in testing should be specified using `limma::makeContrasts` to make the contrast matrix. Confirm that the correct merged clustering is specified.  
  
Design and contrast matrixes are set up similarly to limma, which has a lot of resources on how to set up Design and Contrast matrices for more complicated experiments. Some resources to check out:  
[Bioconductor limma User's Guide](https://www.bioconductor.org/packages/devel/bioc/vignettes/limma/inst/doc/usersguide.pdf)  
[A guide to creating design matrices for gene expression experiments, Law et al, 2020](https://www.bioconductor.org/packages/devel/bioc/vignettes/limma/inst/doc/usersguide.pdf)  
  
  A visual summary of each model should be produced (boxplots, etc.) to assist in evaluating if the model has a performance issue. For example, if there are too many 0s in the data you may get a statisitcally significant functional marker change, which has no biological relevance. Over-fitted models may also give inflated p-values.


## CLI Description

### Stage 0 - Template Ingestion

Create/read in an Excel sheet that defines the panel, the samples, and annotations for analysis.

#### 1. Create a template

```bash
$ masscytometry-templates create ./template.xlsx
```

#### 2. (Optional) Automatically populate the sample file paths and sample names

```bash
$ masscytometry-templates add_samples --samples_path /my/FCS/storage/directory/ --output_path myproject-with-samples.xlsx --sample_name_regex '(\d+_T\d)' template.xlsx
```

#### 3. Fill in the template with project details

##### a. The Panel Parameters

This is an annotation derived from the FCS file header.

##### b. The Panel Definition

If you're not sure what is included in your panel, you can export the panel parameters from any of your FCS files with the following R snippet:

```R
library(flowCore)
fcs <- read.FCS('/my/files/filename.fcs')
df <- pData(parameters(fcs))
write.csv(df, 'markers.csv')
df
```

##### c. The Sample Annotations

##### d. The Metadata

#### 4. Convert the Excel template to an input JSON file

```bash
$ masscytometry-templates ingest --output_ingested_json inputs.json annotated-labeled.xlsx
```

The generated JSON file will serve as the Stage 1 pipeline input.
