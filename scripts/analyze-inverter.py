#!/usr/bin/env python3
"""Extract CMOS inverter switching and noise-margin metrics from ngspice wrdata."""

from __future__ import annotations

import json
import sys
from pathlib import Path


def crossing(xs: list[float], ys: list[float], target: float) -> float | None:
    for index in range(len(xs) - 1):
        a = ys[index] - target
        b = ys[index + 1] - target
        if a == 0:
            return xs[index]
        if a * b <= 0 and ys[index + 1] != ys[index]:
            fraction = (target - ys[index]) / (ys[index + 1] - ys[index])
            return xs[index] + fraction * (xs[index + 1] - xs[index])
    return None


def main() -> int:
    source = Path(sys.argv[1] if len(sys.argv) > 1 else "build/cmos_inverter_vtc.dat")
    rows = []
    for line in source.read_text().splitlines():
        fields = line.split()
        if len(fields) >= 2:
            rows.append((float(fields[0]), float(fields[-1])))
    if len(rows) < 20:
        raise SystemExit(f"not enough VTC samples: {len(rows)}")

    vin = [row[0] for row in rows]
    vout = [row[1] for row in rows]
    slopes = [
        (vout[i + 1] - vout[i - 1]) / (vin[i + 1] - vin[i - 1])
        for i in range(1, len(rows) - 1)
    ]
    slope_x = vin[1:-1]
    slope_plus_one = [slope + 1.0 for slope in slopes]
    crossings = []
    for i in range(len(slope_x) - 1):
        if slope_plus_one[i] * slope_plus_one[i + 1] <= 0:
            x = crossing(
                [slope_x[i], slope_x[i + 1]],
                [slope_plus_one[i], slope_plus_one[i + 1]],
                0.0,
            )
            if x is not None:
                crossings.append(x)

    vm = crossing(vin, [out - inp for inp, out in rows], 0.0)
    vil = crossings[0] if crossings else None
    vih = crossings[-1] if len(crossings) > 1 else None
    voh = vout[0]
    vol = vout[-1]
    result = {
        "pdk": "sky130A",
        "corner": "tt",
        "vdd_v": 1.8,
        "samples": len(rows),
        "device_sizes_um": {"nmos": {"w": 1.0, "l": 0.15}, "pmos": {"w": 2.0, "l": 0.15}},
        "voh_v": voh,
        "vol_v": vol,
        "switching_voltage_v": vm,
        "vil_v": vil,
        "vih_v": vih,
        "noise_margin_low_v": None if vil is None else vil - vol,
        "noise_margin_high_v": None if vih is None else voh - vih,
        "max_gain_magnitude": -min(slopes),
    }
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
