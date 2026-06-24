v {xschem version=3.4.7RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -90 -140 -50 -140 {lab=#net1}
N -10 -50 50 -50 {lab=GND}
N -70 -140 -70 -110 {lab=#net1}
N -130 -110 -70 -110 {lab=#net1}
N -50 -50 -50 -20 {lab=VG}
N -10 -110 -10 -100 {lab=vout}
N -10 -100 -10 -80 {lab=vout}
N -10 -100 40 -100 {lab=vout}
N -130 -230 -130 -170 {lab=VDD}
N -10 -230 -10 -170 {lab=VDD}
N -50 -20 -50 20 {lab=VG}
C {sky130_fd_pr/nfet_01v8.sym} -30 -50 0 0 {name=M1
W=10
L=0.4
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {gnd.sym} -10 -20 0 0 {name=l1 lab=GND}
C {gnd.sym} -130 -50 0 0 {name=l2 lab=GND}
C {gnd.sym} 50 -50 3 0 {name=l5 lab=GND}
C {code.sym} -90 40 0 0 {name=s1 only_toplevel=false value=".lib /usr/local/share/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice tt

vsup VDD 0 1.8

vin vg dc=0 ac=1

.tran 10u 10m
.end

.control 
run
plot v(VG) vs v(vout)
.endc
"}
C {isource.sym} -130 -80 0 0 {name=Ibias value=100u}
C {devices/opin.sym} 40 -100 0 0 {name=p6 lab=vout}
C {devices/iopin.sym} -50 20 0 0 {name=p3 lab=VG
}
C {sky130_fd_pr/pfet3_01v8.sym} -30 -140 0 0 {name=M2
W=10
L=0.4
body= VDD
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet3_01v8.sym} -110 -140 0 1 {name=M4
W=10
L=0.4
body= VDD
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {devices/vdd.sym} -130 -230 0 0 {name=l4 lab=VDD}
C {devices/vdd.sym} -10 -230 0 0 {name=l3 lab=VDD}
