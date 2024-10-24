# [notebooks/02 - Python - Create metadata template.ipynb](/notebooks/02%20-%20Python%20-%20Create%20metadata%20template.ipynb)

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