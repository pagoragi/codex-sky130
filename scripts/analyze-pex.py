#!/usr/bin/env python3
"""Summarize parasitic devices in a Magic-generated PEX netlist."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


def main() -> int:
    source = Path(sys.argv[1])
    lines = source.read_text().splitlines()
    resistors = [line for line in lines if re.match(r"^R\d+\s", line)]
    capacitors = [line for line in lines if re.match(r"^C\d+\s", line)]
    transistors = [line for line in lines if re.match(r"^X\d+\s", line)]
    if not resistors or not capacitors:
        raise SystemExit("PEX netlist does not contain both resistance and capacitance")
    result = {
        "source": str(source),
        "transistor_instances": len(transistors),
        "resistor_instances": len(resistors),
        "capacitor_instances": len(capacitors),
    }
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
