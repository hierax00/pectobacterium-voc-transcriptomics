#!/bin/bash
# =============================================================================
# 05_quantification.sh
# Purpose : Pseudoalign cleaned reads and estimate transcript abundances
# Input   : limpio_*_R1.fastq.gz.gz (cleaned reads) + organism.idx (index)
# Output  : resultados_<sample>/ folders, each containing:
#             abundance.tsv    — transcript-level counts (input for R/tximport)
#             abundance.h5     — HDF5 format (optional, for sleuth)
#             run_info.json    — run metadata
# Parameters:
#   -b 100 : bootstrap samples for uncertainty estimation (min 100 recommended)
#   -t 16  : threads (adjust to your machine)
# =============================================================================

set -euo pipefail

INDEX="pectobacterium.idx"  # must match 04_build_index.sh output
THREADS=16
BOOTSTRAPS=100

echo "========================================"
echo "  Step 5: Quantification with Kallisto"
echo "========================================"

if [[ ! -f "$INDEX" ]]; then
    echo "ERROR: Index file '$INDEX' not found. Run 04_build_index.sh first."
    exit 1
fi

for r1 in limpio_*_R1.fastq.gz; do
    r2="${r1/_R1.fastq.gz/_R2.fastq.gz}"
    nombre_base="${r1/limpio_/}"
    nombre_base="${nombre_base/_R1.fastq.gz/}"
    output_dir="resultados_${nombre_base}"

    # Skip if output already exists
    if [[ -d "$output_dir" ]]; then
        echo "  [SKIP] ${nombre_base} — output folder already exists"
        continue
    fi

    echo "  Quantifying: ${nombre_base}"

    kallisto quant \
        -i "$INDEX" \
        -o "$output_dir" \
        -b "$BOOTSTRAPS" \
        -t "$THREADS" \
        "$r1" "$r2"

    echo "  Done: ${nombre_base} → ${output_dir}/abundance.tsv"
    echo "  ----------------------------------------"
done

echo ""
echo "Quantification complete."
echo "Output folders: resultados_*/"
echo "Next step: import into R using tximport (see ../1_ExploratoryAnalysis.Rmd)"
