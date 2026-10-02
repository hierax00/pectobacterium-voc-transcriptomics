# Preprocessing (Linux)

Bash steps run on Ubuntu 22.04 (WSL) before the R analysis. Run them in order
from the directory that holds the raw `*_R1.fastq.gz` / `*_R2.fastq.gz` files.

| Step | Script | Tool (version used) | Key parameters |
|------|--------|---------------------|----------------|
| 1 | `01_quality_control.sh` | fastp 1.1.0 | `-q 30 -l 50` |
| 2 | `02_taxonomic_check.sh` | Kraken2 2.17.1, Krona 2.8.1 | `--paired`, database `k2_standard_08gb_20240112` |
| 3 | `03_multiqc_report.sh` | MultiQC 1.33 | |
| 4 | `04_build_index.sh` | kallisto 0.51.1 | k = 31 (default) |
| 5 | `05_quantification.sh` | kallisto 0.51.1 | `-b 100` |

Inputs that are not tracked in this repository:

- Raw reads: NCBI BioProject PRJNA1533106.
- Reference: "CDS from genomic" FASTA of *Pectobacterium aroidearum* SM2
  (assembly JBCFOM000000000.1, 4,572 coding sequences).
- Kraken2 database:
  `https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08gb_20240112.tar.gz`

The per-sample `abundance.tsv` files produced by step 5 are the files in
`data/counts/` (`C1`, `C2`, `T1`, `T2`). The Kraken2 report for control
replicate 1 is `data/taxonomy/reporte_taxonomia.txt`.
