v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {SKY130A 1.8 V CMOS Inverter} 180 -500 0 0 0.6 0.6 {}
T {WN=1.0 um  WP=2.0 um  L=0.15 um} 180 -470 0 0 0.4 0.4 {}
N 360 -320 410 -320 {lab=in}
N 360 -180 410 -180 {lab=in}
N 360 -320 360 -180 {lab=in}
N 300 -250 360 -250 {lab=in}
N 450 -290 450 -210 {lab=out}
N 450 -250 530 -250 {lab=out}
N 450 -370 450 -350 {lab=vdd}
N 450 -370 530 -370 {lab=vdd}
N 530 -370 530 -320 {lab=vdd}
N 450 -320 530 -320 {lab=vdd}
N 450 -150 450 -130 {lab=0}
N 450 -180 530 -180 {lab=0}
N 530 -180 530 -130 {lab=0}
N 450 -130 530 -130 {lab=0}
N 180 -300 180 -270 {lab=vdd}
N 180 -210 180 -180 {lab=0}
C {sky130_fd_pr/pfet_01v8.sym} 430 -320 0 0 {name=M1
L=0.15
W=2.0
nf=1 mult=1
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 430 -180 0 0 {name=M2
L=0.15
W=1.0
nf=1 mult=1
model=nfet_01v8
spiceprefix=X
}
C {devices/vsource.sym} 180 -240 0 0 {name=VDD value=1.8 savecurrent=true}
C {devices/vsource.sym} 300 -220 0 0 {name=VIN value=0 savecurrent=false}
C {devices/gnd.sym} 180 -180 0 0 {name=l1 lab=0}
C {devices/gnd.sym} 300 -190 0 0 {name=l2 lab=0}
C {devices/gnd.sym} 450 -130 0 0 {name=l3 lab=0}
C {devices/lab_wire.sym} 180 -300 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {devices/lab_wire.sym} 450 -370 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {devices/lab_wire.sym} 300 -250 0 1 {name=p2 sig_type=std_logic lab=in}
C {devices/lab_wire.sym} 530 -250 0 1 {name=p3 sig_type=std_logic lab=out}
C {/foss/pdks/sky130A/libs.tech/xschem/sky130_fd_pr/corner.sym} 750 -380 0 0 {name=CORNER only_toplevel=false corner=tt}
C {devices/code_shown.sym} 690 -180 0 0 {name=SIM only_toplevel=false value=".control
set noaskquit
set wr_singlescale
dc VIN 0 1.8 0.005
wrdata cmos_inverter_vtc.dat v(out)
meas dc vm when v(out)=v(in)
quit
.endc"}
C {devices/title.sym} 160 -40 0 0 {name=l4 author="Codex"}
