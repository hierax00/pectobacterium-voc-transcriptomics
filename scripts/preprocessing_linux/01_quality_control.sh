#!/bin/bash
# =============================================================================
# 01_quality_control.sh
# Purpose : Trim and filter paired-end reads using fastp
# Parameters:
#   -q 30  : minimum Phred quality score per base
#   -l 50  : minimum read length after trimming
#   -w 16  : number of threads (adjust to your machine)
# Output  : limpio_*_R1.fastq.gz / limpio_*_R2.fastq.gz + HTML reports
# =============================================================================

set -euo pipefail  # exit on error, undefined variable, or pipe failure

echo "========================================"
echo "  Step 1: Quality Control with fastp"
echo "========================================"

for r1 in *_R1.fastq.gz; do

    r2="${r1/_R1.fastq.gz/_R2.fastq.gz}"
    nombre_base="${r1/_R1.fastq.gz/}"

    # Skip if output already exists (allows re-running safely)
    if [[ -f "limpio_${r1}" ]]; then
        echo "  [SKIP] ${nombre_base} — output already exists"
        continue
    fi

    echo "  Processing: ${nombre_base}"

    fastp \
        -i "$r1" -I "$r2" \
        -o "limpio_${r1}" -O "limpio_${r2}" \
        -q 30 \
        -l 50 \
        -w 16 \
        -h "reporte_fastp_${nombre_base}.html"

    echo "  Done: ${nombre_base}"
    echo "  ----------------------------------------"
done

echo ""
echo "All samples processed. Check HTML reports for QC summary."
