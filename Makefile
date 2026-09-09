SHELL := /bin/bash

.PHONY: start stop status doctor smoke inverter-netlist inverter-sim inverter inverter-layout inverter-drc inverter-extract inverter-lvs inverter-pex inverter-pex-sim inverter-gds inverter-layout-check xschem magic klayout shell clean

start:
	@./bin/start

stop:
	@./bin/stop

status:
	@./bin/status

doctor:
	@mkdir -p build
	@./bin/eda doctor | tee runtime-manifest.json

smoke:
	@./bin/eda run mkdir -p build
	@./bin/eda run ngspice -b -o build/sky130_nmos_dc.log tests/sky130_nmos_dc.spice
	@./bin/eda run ./scripts/check-smoke.sh build/sky130_nmos_dc.log build/sky130_nmos_dc.dat

inverter-netlist:
	@./bin/eda run mkdir -p build
	@./bin/eda run xschem --rcfile xschemrc -x -q -n -s -o build design/xschem/cmos_inverter.sch
	@./bin/eda run test -s build/cmos_inverter.spice

inverter-sim:
	@./bin/eda run mkdir -p build
	@./bin/eda run ngspice -b -o build/cmos_inverter.log tests/cmos_inverter_dc.spice
	@./bin/eda run test -s build/cmos_inverter_vtc.dat
	@./bin/eda run bash -c 'python3 scripts/analyze-inverter.py build/cmos_inverter_vtc.dat | tee build/cmos_inverter_metrics.json'

inverter: inverter-netlist inverter-sim

inverter-layout:
	@mkdir -p build/inverter-layout
	@test -s design/magic/cmos_inverter_layout.mag
	@test -s design/magic/sky130_fd_pr__nfet_01v8_PNATEX.mag
	@test -s design/magic/sky130_fd_pr__pfet_01v8_RLCJU3.mag

inverter-drc: inverter-layout
	@./bin/eda run magic -dnull -noconsole -rcfile /foss/pdks/sky130A/libs.tech/magic/sky130A.magicrc scripts/inverter-drc.tcl | tee build/inverter-layout/drc.log
	@test "$$(cat build/inverter-layout/drc-count.txt)" = "0"

inverter-extract: inverter-layout
	@./bin/eda run magic -dnull -noconsole -rcfile /foss/pdks/sky130A/libs.tech/magic/sky130A.magicrc scripts/inverter-extract.tcl | tee build/inverter-layout/extract.log
	@test -s build/inverter-layout/cmos_inverter_layout.spice

inverter-lvs: inverter-extract
	@./bin/eda run bash -lc 'netgen -batch lvs "build/inverter-layout/cmos_inverter_layout.spice cmos_inverter_flat" "design/spice/cmos_inverter_lvs.spice cmos_inverter_layout" "$$PDKPATH/libs.tech/netgen/sky130A_setup.tcl" build/inverter-layout/lvs.log'
	@grep -q "Circuits match uniquely" build/inverter-layout/lvs.log

inverter-pex: inverter-layout
	@./bin/eda run magic -dnull -noconsole -rcfile /foss/pdks/sky130A/libs.tech/magic/sky130A.magicrc scripts/inverter-pex.tcl | tee build/inverter-layout/pex.log
	@./bin/eda run test -s build/inverter-layout/cmos_inverter_pex.spice
	@./bin/eda run bash -c 'python3 scripts/analyze-pex.py build/inverter-layout/cmos_inverter_pex.spice | tee build/inverter-layout/pex-summary.json'

inverter-pex-sim: inverter-pex
	@./bin/eda run ngspice -b -o build/inverter-layout/pex-tran.log tests/cmos_inverter_pex_tran.spice
	@./bin/eda run test -s build/inverter-layout/cmos_inverter_pex_tran.dat

inverter-gds: inverter-layout
	@./bin/eda run magic -dnull -noconsole -rcfile /foss/pdks/sky130A/libs.tech/magic/sky130A.magicrc scripts/inverter-gds.tcl | tee build/inverter-layout/gds.log
	@test -s build/inverter-layout/cmos_inverter_layout.gds

inverter-layout-check: inverter-drc inverter-lvs

xschem:
	@./bin/eda xschem

magic:
	@./bin/eda magic

klayout: inverter-gds
	@./bin/eda klayout

shell:
	@./bin/eda shell

clean:
	@./bin/eda run rm -f build/sky130_nmos_dc.log build/sky130_nmos_dc.dat
	@./bin/eda run rm -f build/cmos_inverter.spice build/cmos_inverter.log build/cmos_inverter_vtc.dat build/cmos_inverter_metrics.json
	@./bin/eda run rm -rf build/inverter-layout
	@rm -f runtime-manifest.json
