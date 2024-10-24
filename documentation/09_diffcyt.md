# [notebooks/09 - R - Pre vs Post statisitcs.ipynb](/notebooks/09%20-%20R%20-%20Pre%20vs%20Post%20statisitcs.ipynb)

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