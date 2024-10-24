# [notebooks/08 - Python - Output data.ipynb](/notebooks/08%20-%20Python%20-%20Output%20data.ipynb)
  
Save primary per-cell data and cell-type frequency, cell-type expression, and pseudobulk expression data.
  
**Pre-requisites:** Requires the intermediate files from both `stage_1` and `stage_2`, as well as our completed metadata.
  
**Post:** Some primary data outputs suitable for further analysis:
  
- `WORKFLOW/stage_2/Data_01_cellular_data.parquet`: A one-cell-per-row file with the cluster label of each cell, metadata labels, calculated UMAP embedding, and the expression of each marker (arcsinh transformed).
- `WORKFLOW/stage_2/Data_02_cell_type_percent.csv`: For each sample, the percentage of each cell type present.
- `WORKFLOW/stage_2/Data_03_cell_type_expression_mean_median.csv`: For each cell type in each sample, the mean and median expressions of each marker.
- `WORKFLOW/stage_2/Data_04_pseudobulk_expression_mean_median.csv`: For each sample, the pseudobulk mean and median expression of each marker.
  
Note: you could do this step using R instead.