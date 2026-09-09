cd design/magic
load cmos_inverter_layout
select top cell
expand
flatten cmos_inverter_flat
load cmos_inverter_flat
select top cell
extract do local
extract no capacitance
extract no resistance
extract all
ext2spice lvs
ext2spice cthresh infinite
ext2spice rthresh infinite
ext2spice -o ../../build/inverter-layout/cmos_inverter_layout.spice cmos_inverter_flat.ext
quit -noprompt
