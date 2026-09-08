SHELL := /bin/bash

.PHONY: start stop status doctor smoke inverter-netlist inverter-sim inverter xschem shell clean

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

xschem:
	@./bin/eda xschem

shell:
	@./bin/eda shell

clean:
	@./bin/eda run rm -f build/sky130_nmos_dc.log build/sky130_nmos_dc.dat
	@./bin/eda run rm -f build/cmos_inverter.spice build/cmos_inverter.log build/cmos_inverter_vtc.dat build/cmos_inverter_metrics.json
	@rm -f runtime-manifest.json
