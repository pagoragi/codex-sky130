# SKY130 EDA operating rules

- Run EDA only through `make` targets or `bin/eda`.
- Use the IIC-OSIC-TOOLS container and explicitly select `sky130A` for every run.
- Treat native schematics, netlists, layouts, PDK files, logs, and reports as authoritative.
- Never edit anything below `/foss/pdks` or `/foss/tools`.
- Do not report success from an exit status alone; inspect logs and generated artifacts.
- Record tool versions and PDK paths before substantive runs.
- After schematic changes, regenerate the netlist and rerun the relevant simulations.
- After layout changes, rerun DRC, extraction, and LVS.
- Distinguish tool execution success from electrical specification compliance.
- Make one design-variable class of changes per optimization iteration.
