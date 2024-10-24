### [notebooks/00 - Python - Stage example data.ipynb](https://github.com/allison-nau/cio-mass-cytometry/blob/main/notebooks/00%20-%20Python%20-%20Stage%20example%20data.ipynb)

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