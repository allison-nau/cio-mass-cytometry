# [notebooks/05 - Python - Generate cluster template.ipynb](/notebooks/05%20-%20Python%20-%20Generate%20cluster%20template.ipynb)

Take the CATALYST outputs and produce a worksheet of unlabeled clusters and generate figures.

**Pre-requisites:** Uses the metadata converted JSON `WORKFLOW/stage_1/04-metadata-completed.json`, and the four `WORKFLOW/stage_1/Intermediate_*` files from the previous step.

**Post:** Creates a worksheet template for labeling clusters in `WORKFLOW/stage_1/05-stage1-unannotated-clusters-50.xlsx`.

### *Not shown in notebook:* Accurately annotate all clusters in the over-clustered Excel sheet

You download the worksheet and you can use it in conjunction with the stage_1 CATALYST workflow to fill in which cell population each cluster represents. Take notice of the percentage of cellularity of each population because there may be some very small populations that are not easily classified but may be better to just set to an unknown or other label.

**Pre-requisites:** Take the unlabeled worksheet `WORKFLOW/stage_1/05-stage1-unannotated-clusters-50.xlsx`.

**Post:** The saved labeled worksheet `WORKFLOW/stage_2/06-INPUT-stage2-annotated-clusters-50.xlsx`; note this marks our switch from stage 1 of the workflow to stage 2.

👁️ **Review required:** We recommend working with an immunologist to complete this section.