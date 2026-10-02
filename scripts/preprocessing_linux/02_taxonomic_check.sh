#!/bin/bash
# =============================================================================
# 02_taxonomic_check.sh
# Purpose : Confirm reads belong to your target organism (contamination QC)
#           Kraken2 classifies reads taxonomically; Krona visualizes results
# Input   : cleaned reads from 01_quality_control.sh (limpio_*_R1.fastq.gz)
# Output  : reporte_taxonomia_<sample>.txt + krona_<sample>.html
# NOTE    : Run ONE sample first to visually inspect before processing all
# =============================================================================

set -euo pipefail

KRAKEN_DB="kraken_db/k2_standard_08gb_20240112"
THREADS=16

echo "========================================"
echo "  Step 2: Taxonomic Classification"
echo "========================================"

# In this study only control replicate 1 was classified (the report shipped in
# data/taxonomy/reporte_taxonomia.txt); the loop below classifies every sample.
for r1 in limpio_*_R1.fastq.gz; do

    r2="${r1/_R1.fastq.gz/_R2.fastq.gz}"
    nombre_base="${r1/limpio_/}"
    nombre_base="${nombre_base/_R1.fastq.gz/}"

    echo "  Classifying: ${nombre_base}"

    # --- Kraken2 ---
    kraken2 \
        --db "$KRAKEN_DB" \
        --threads "$THREADS" \
        --paired "$r1" "$r2" \
        --report "reporte_taxonomia_${nombre_base}.txt" \
        > /dev/null   # discard per-read output to save disk space

    # --- Krona visualization ---
    ktImportTaxonomy \
        -q 2 -t 5 \
        "reporte_taxonomia_${nombre_base}.txt" \
        -o "krona_${nombre_base}.html"

    echo "  Done: ${nombre_base} — open krona_${nombre_base}.html to inspect"
    echo "  ----------------------------------------"
done

echo ""
echo "Taxonomic check complete."
echo "Open the Krona HTML files in a browser to verify organism identity."
echo "If >10% of reads classify to unexpected organisms, investigate before continuing."
