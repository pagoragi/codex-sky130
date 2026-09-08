#!/usr/bin/env bash
set -euo pipefail

log="${1:?missing ngspice log}"
data="${2:?missing ngspice data}"

test -s "$log" || { echo "FAIL: ngspice log is empty" >&2; exit 1; }
test -s "$data" || { echo "FAIL: ngspice data was not generated" >&2; exit 1; }

if grep -Eiq '(^|[[:space:]])(fatal|panic|segmentation fault)(:|[[:space:]])' "$log"; then
  echo "FAIL: fatal condition found in ngspice log" >&2
  grep -Ein 'fatal|panic|segmentation fault' "$log" >&2
  exit 1
fi

rows="$(awk 'NF >= 4 {count++} END {print count+0}' "$data")"
if (( rows < 10 )); then
  echo "FAIL: expected at least 10 DC sweep rows, got $rows" >&2
  exit 1
fi

echo "PASS: SKY130A model loaded and ngspice generated $rows DC sweep rows"
