#!/bin/bash
# =============================================================================
# 03_multiqc_report.sh
# Purpose : Aggregate all fastp and Kraken2 reports into one HTML dashboard
# Output  : multiqc_report.html in current directory
# Run     : After 01 and 02 are complete
# =============================================================================

set -euo pipefail

echo "========================================"
echo "  Step 3: Aggregate QC with MultiQC"
echo "========================================"

multiqc . --filename multiqc_report.html --force

echo ""
echo "Done. Open multiqc_report.html to review all samples together."
echo "Check for:"
echo "  - Consistent read quality across samples"
echo "  - No outlier samples with very low read counts"
echo "  - Similar duplication rates"
