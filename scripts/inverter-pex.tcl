cd design/magic
load cmos_inverter_layout
select top cell
expand
flatten cmos_inverter_pex
load cmos_inverter_pex
select top cell
extract do local
extract do capacitance
extract do coupling
extract do resistance
extract all
extresist threshold 0
extresist minresist 0
extresist simplify off
extresist all
ext2spice default
ext2spice format ngspice
ext2spice hierarchy off
ext2spice extresist on
ext2spice cthresh 0
ext2spice rthresh 0
ext2spice -o ../../build/inverter-layout/cmos_inverter_pex.spice cmos_inverter_pex.ext
quit -noprompt
