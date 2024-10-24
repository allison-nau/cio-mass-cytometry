# CLI Description

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
