cd design/magic
load cmos_inverter_layout
select top cell
expand
gds write ../../build/inverter-layout/cmos_inverter_layout.gds
quit -noprompt
