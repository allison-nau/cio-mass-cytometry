# [notebooks/01 - R - Get Panel details.ipynb](/notebooks/01%20-%20R%20-%20Get%20Panel%20details.ipynb)

This step extracts information about the panel run from the FCS files and ensures that panel details are consistent across FCS files. This will be used to fill in the metadata accurately.

**Pre-requisites:** Requires the FCS files.

**Post:** Extracts the header table from one of the FCS files.

👁️ **Review required:** You need to check that all FCS files are defined by this same table by checking that their hashes are all identical.
  
Note: if you discover that the naming of your fcs file parameters is inconsistent across fcs files (e.g. PD1 vs PD-1), you can use a lool like [ParkerICI/premessa::paneleditor_GUI()](https://github.com/ParkerICI/premessa) to assist in harmonizing your fcs files.