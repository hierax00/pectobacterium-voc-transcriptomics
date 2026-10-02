#!/bin/bash
# =============================================================================
# 04_build_index.sh
# Purpose : Build Kallisto index from bacterial CDS reference
# Input   : transcriptoma.fna — CDS FASTA from NCBI RefSeq
# Output  : organism.idx — binary index file used by Kallisto quant
#
# IMPORTANT for bacteria:
#   Use the CDS (coding sequences) file, NOT the full genome.
#   Download from NCBI RefSeq: search your strain → CDS from genomic FASTA
#   For Pectobacterium: https://www.ncbi.nlm.nih.gov/datasets/genome/
# =============================================================================

set -euo pipefail

REFERENCE="cds_from_genomic.fna"   # CDS FASTA of P. aroidearum SM2 (JBCFOM000000000.1)
INDEX_NAME="pectobacterium.idx"

echo "========================================"
echo "  Step 4: Build Kallisto Index"
echo "========================================"

if [[ ! -f "$REFERENCE" ]]; then
    echo "ERROR: Reference file '$REFERENCE' not found."
    echo "Download CDS FASTA from NCBI RefSeq and place it in this directory."
    exit 1
fi

kallisto index -i "$INDEX_NAME" "$REFERENCE"

echo ""
echo "Index built: ${INDEX_NAME}"
echo "This file is reusable — no need to rebuild unless you change the reference."
