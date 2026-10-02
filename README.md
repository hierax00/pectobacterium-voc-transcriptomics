# RNA-seq analysis of *Pectobacterium aroidearum* SM2 under VOC stress
[![DOI](https://zenodo.org/badge/1401076277.svg)](https://doi.org/10.5281/zenodo.23095575)

Code, processed data and results for the transcriptomic analysis in:

> Mena Navarro M.P., López Chablé U., Reyes Betanzo C., Arvizu Gómez J.L.,
> Valenzuela Soto J.H., Ramos López M.A., Amaro Reyes A., Hernández Flores J.L.,
> Campos Guillén J. *Electrochemical impedance and transcriptomic analysis in
> Pectobacterium aroidearum SM2 under VOC's-stress during early colonization.*
> Submitted to *Microorganisms* (2026).

*P. aroidearum* SM2 was exposed for 1 h to volatile organic compounds (VOCs)
from a cell-free filtrate of *Kosakonia cowanii* Cp1 and compared with an
untreated control (two replicates per condition).

A generalized, organism-agnostic version of this workflow is available as
[rnaseq-bacteria-cookbook](https://github.com/hierax00/rnaseq-bacteria-cookbook)
(doi: [10.5281/zenodo.20849957](https://doi.org/10.5281/zenodo.20849957)).

## Repository layout

```
pectobacterium-voc-transcriptomics/
├── data/
│   ├── metadata_all.csv            # Sample sheet: condition, replicate, batch
│   ├── annotation.tsv              # eggNOG-mapper v2 functional annotation
│   ├── counts/                     # kallisto abundance tables (C1, C2, T1, T2)
│   └── taxonomy/
│       └── reporte_taxonomia.txt   # Kraken2 report (control replicate 1)
├── scripts/
│   ├── preprocessing_linux/        # fastp, Kraken2, MultiQC, kallisto (Bash)
│   ├── 00_PackageInstallation.Rmd
│   ├── 0_TaxonomyReport.Rmd
│   ├── 1_ExploratoryAnalysis.Rmd
│   ├── 2_DataNormalization.Rmd
│   ├── 3_DifferentialExpression.Rmd
│   ├── 4_FunctionalCategorization.Rmd
│   ├── 5_AdvancedAnalysis.Rmd
│   ├── 6_PaperFigures.Rmd
│   └── *.pdf                       # Knitted reports, each ending in sessionInfo()
└── results/
    ├── *.csv, *.pdf                # Count matrices, DESeq2 tables, QC plots
    ├── taxonomy/
    ├── enrichment/                 # GO / KEGG over-representation, pathview maps
    ├── advanced_analysis/          # GSEA, virulence, regulators, PPI network
    ├── TIFFs/                      # 300 dpi versions of the plots above
    └── paper_images/               # Final manuscript figures
```

## How to reproduce

1. **Preprocessing (optional).** `data/counts/` already contains the kallisto
   output. To regenerate it from raw reads, see
   [`scripts/preprocessing_linux/`](scripts/preprocessing_linux/README.md).
2. **R packages.** Knit `scripts/00_PackageInstallation.Rmd` once.
3. **Analysis.** Open `paper-pectobaterium-rnaseq.Rproj` in RStudio and knit the
   scripts in numerical order, `1` → `6`. Each script reads from `../data` and
   `../results` and writes to `../results`, so the working directory must be
   `scripts/` (the RStudio default when knitting).

`0_TaxonomyReport.Rmd` is independent of the others. Scripts 4–6 need internet
access (KEGG and STRING downloads).

| Script | What it does | Main outputs |
|--------|--------------|--------------|
| `1_ExploratoryAnalysis` | tximport, low-count filter (row mean > 10), VST, PCA | `rawcounts.csv`, `filtcounts.csv`, `pca_raw.pdf` |
| `2_DataNormalization` | ComBat-seq batch adjustment, DESeq2 size factors | `adjcounts.csv`, `normcounts.csv`, `pca_adj.pdf`, `boxplots.pdf` |
| `3_DifferentialExpression` | Wald test, volcano plot, DEG heatmap | `deseq_results_Treatment_vs_Control.csv`, `deg_Treatment_vs_Control.csv` |
| `4_FunctionalCategorization` | GO and KEGG over-representation, pathview maps | `enrichment/`, `advanced_analysis/full_annotated_results.csv` |
| `5_AdvancedAnalysis` | GSEA, virulence and regulator profiling, STRING network | `advanced_analysis/` |
| `6_PaperFigures` | Final figures at 1200 dpi | `paper_images/` |

## Conventions

- **Direction of change.** The contrast is Treatment vs Control
  (`contrast = c("Condition", "Treatment", "Control")`): a positive log2 fold
  change means higher expression in VOC-treated cells.
- **Differentially expressed genes (DEGs).** Adjusted p < 0.01 and
  |log2FC| > 1. This gives 216 DEGs out of 4,566 tested genes (68 up, 148 down).
- **Gene identifiers.** Counts are indexed by the RefSeq CDS identifier
  (`lcl|NZ_JBCFOM...cds_WP_xxxxxxxxx.1_n`); the `WP_` protein accession is the
  key that links to `annotation.tsv`.
- **Batch.** The two replicates of each condition were processed in separate
  batches (`batch` column of `metadata_all.csv`). Counts are adjusted with
  ComBat-seq and then modelled with `design = ~ Condition`.

## Software

R 4.5.2 with Bioconductor 3.22 (DESeq2 1.50.2, tximport 1.38.2, sva 3.58.0,
clusterProfiler 4.18.4, STRINGdb 2.22.0 against STRING v11.5). Preprocessing:
fastp 1.1.0, Kraken2 2.17.1, MultiQC 1.33, kallisto 0.51.1. Complete version
lists are in the `sessionInfo()` section of each knitted PDF in `scripts/`.

## Data availability

Raw sequencing reads: NCBI BioProject
[PRJNA1533106](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1533106)
(BioSample SAMN63298801). Reference genome: *P. aroidearum* SM2, GenBank
JBCFOM000000000.1.

## Citation

Please cite the article above. Citation metadata for this repository is in
[`CITATION.cff`](CITATION.cff).

## License

Code is released under the [MIT License](LICENSE).
