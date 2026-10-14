#!/usr/bin/env bash
# Convert the source file (a single JSON array) into newline-delimited JSON,
# which is the format BigQuery expects for JSON loads.
#
# Usage: ./scripts/convert_to_ndjson.sh TransactionData.json transactions.ndjson

set -euo pipefail

INPUT="${1:-TransactionData.json}"
OUTPUT="${2:-transactions.ndjson}"

jq -c '.[]' "$INPUT" > "$OUTPUT"

echo "Wrote $(wc -l < "$OUTPUT") records to $OUTPUT"
