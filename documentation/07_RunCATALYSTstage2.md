# [notebooks/07 - R - Run CATALYST stage 2.ipynb](/notebooks/07%20-%20R%20-%20Run%20CATALYST%20stage%202.ipynb)

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