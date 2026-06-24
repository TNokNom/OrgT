v {xschem version=3.4.7RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 1420 -470 1470 -470 {
lab=g1}
N 1510 -400 1510 -340 {
lab=GND}
N 1510 -470 1590 -470 {
lab=GND}
N 1590 -470 1590 -400 {
lab=GND}
N 1510 -400 1590 -400 {
lab=GND}
N 1510 -640 1510 -510 {
lab=d1}
N 1510 -640 1660 -640 {
lab=d1}
N 1510 -440 1510 -400 {
lab=GND}
N 1510 -510 1510 -500 {
lab=d1}
N 1510 -780 1510 -640 {
lab=d1}
N 1510 -920 1510 -840 {
lab=VDD}
N 1320 -470 1320 -440 {
lab=g1}
N 1320 -470 1420 -470 {
lab=g1}
N 1320 -380 1320 -340 {
lab=GND}
N 1210 -430 1280 -430 {
lab=d1}
N 1210 -640 1210 -430 {
lab=d1}
N 1210 -640 1510 -640 {
lab=d1}
N 1130 -390 1280 -390 {
lab=ref}
N 1320 -560 1390 -560 {
lab=g1}
N 1320 -560 1320 -470 {
lab=g1}
N 910 -920 910 -840 {
lab=VDD}
N 950 -810 1470 -810 {
lab=#net1}
N 910 -790 910 -710 {
lab=#net1}
N 920 -740 990 -740 {
lab=#net1}
N 990 -810 990 -740 {
lab=#net1}
N 910 -640 910 -600 {
lab=GND}
N 2120 -410 2120 -350 {
lab=GND}
N 2120 -480 2200 -480 {
lab=GND}
N 2200 -480 2200 -410 {
lab=GND}
N 2120 -410 2200 -410 {
lab=GND}
N 2120 -650 2120 -520 {
lab=vout}
N 2120 -450 2120 -410 {
lab=GND}
N 2120 -520 2120 -510 {
lab=vout}
N 2120 -790 2120 -650 {
lab=vout}
N 2120 -930 2120 -850 {
lab=VDD}
N 2020 -820 2080 -820 {
lab=#net1}
N 2020 -480 2080 -480 {
lab=g2}
N 810 -810 910 -810 {
lab=VDD}
N 810 -870 810 -810 {
lab=VDD}
N 810 -870 910 -870 {
lab=VDD}
N 1510 -810 1610 -810 {
lab=VDD}
N 1610 -870 1610 -810 {
lab=VDD}
N 1510 -870 1610 -870 {
lab=VDD}
N 2010 -820 2010 -740 {
lab=#net1}
N 2010 -820 2020 -820 {
lab=#net1}
N 2120 -620 2250 -620 {
lab=vout}
N 2120 -820 2220 -820 {
lab=VDD}
N 2220 -890 2220 -820 {
lab=VDD}
N 2120 -890 2220 -890 {
lab=VDD}
N 910 -740 920 -740 {lab=#net1}
N 910 -710 910 -700 {lab=#net1}
N 1690 -740 2010 -740 {lab=#net1}
N 1690 -1040 1690 -740 {lab=#net1}
N 1190 -1040 1690 -1040 {lab=#net1}
N 1190 -1040 1190 -810 {lab=#net1}
C {devices/code_shown.sym} 40 -1030 0 0 {name=NGSPICE
only_toplevel=true
value="
.lib /usr/local/share/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice tt
.option wnflag = 1

vds ref 0 0.9
vsup VDD 0 1.8
vin g1 g2 dc=0 ac=1

*cinf bias1 0 1n
*cload vout 0 100f

.control
save all

save @m.xm4.msky130_fd_pr__nfet_01v8_lvt[gm]
save @m.xm4.msky130_fd_pr__nfet_01v8_lvt[id]
save @m.xm4.msky130_fd_pr__nfet_01v8_lvt[gds]

save @m.xm5.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.xm5.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.xm5.msky130_fd_pr__pfet_01v8_lvt[gds]

dc vin -1 1 0.001

let gdsn = @m.xm4.msky130_fd_pr__nfet_01v8_lvt[gds]
let gdsp = @m.xm5.msky130_fd_pr__pfet_01v8_lvt[gds]

let gmn = @m.xm4.msky130_fd_pr__nfet_01v8_lvt[gm]
let idn = @m.xm4.msky130_fd_pr__nfet_01v8_lvt[id]

let gmp = @m.xm5.msky130_fd_pr__pfet_01v8_lvt[gm]
let idp = @m.xm5.msky130_fd_pr__pfet_01v8_lvt[id]

let gmoveridn = gmn / idn
let vovn = 2 * idn / gmn

let gmoveridp = gmp / idp
let vovp = 2 * idp / gmp

let ao = gmn / (gdsn + gdsp)

plot v(vout)
plot deriv(v(vout)) vs v(vout) ao vs v(vout)
plot gmoveridn vs v(vout) gmoveridp vs v(vout)
plot vovn vs v(vout) vovp vs v(vout)

* Save DC sweep results
setplot dc1
write dc.raw

ac dec 100 1 1T
plot  v(g2) vdb(vout)

* Save AC response
setplot ac1
write ac.raw

set sqrnoise
noise v(vout) vin dec 100 1 1T

* Save noise spectrum (this is what you want to view)
setplot noise1
plot 10*log10(onoise_spectrum)
write noise.raw

* Save integrated noise result separately
setplot noise2
print onoise_total
write integrated_noise.raw

.endc
" }
C {devices/iopin.sym} 1660 -640 0 0 {name=p2 lab=d1}
C {devices/gnd.sym} 1510 -340 0 0 {name=l3 lab=GND}
C {devices/isource.sym} 910 -670 0 0 {name=I0 value=100u}
C {devices/vdd.sym} 1510 -920 0 0 {name=l1 lab=VDD}
C {devices/vcvs.sym} 1320 -410 0 0 {name=E1 value=1000}
C {devices/gnd.sym} 1320 -340 0 0 {name=l2 lab=GND}
C {devices/ipin.sym} 1130 -390 0 0 {name=p1 lab=ref}
C {devices/iopin.sym} 1390 -560 0 0 {name=p3 lab=g1}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 1490 -470 0 0 {name=M1
L=0.45
W=10
nf=10
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 1490 -810 0 0 {name=M2
L=1
W=50
nf=10
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 930 -810 0 1 {name=M3
L=1
W=50
nf=10
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {devices/vdd.sym} 910 -920 0 0 {name=l4 lab=VDD}
C {devices/gnd.sym} 910 -600 0 0 {name=l5 lab=GND}
C {devices/gnd.sym} 2120 -350 0 0 {name=l6 lab=GND}
C {devices/vdd.sym} 2120 -930 0 0 {name=l7 lab=VDD}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 2100 -480 0 0 {name=M4
L=0.45
W=10
nf=10
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {devices/iopin.sym} 2020 -480 2 0 {name=p5 lab=g2
}
C {devices/opin.sym} 2250 -620 0 0 {name=p6 lab=vout}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 2100 -820 0 0 {name=M5
L=1
W=50
nf=10
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
