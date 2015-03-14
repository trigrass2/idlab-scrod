#!/bin/sh

# Clean up the results directory
rm -rf results
mkdir results

# Synthesize the Example Design
echo 'Synthesizing the example design with XST';
xst -ifn xst.scr
cp ethercon_example_design.ngc ./results/

# Copy the netlist generated by Coregen
echo 'Copying files from the netlist directory to the results directory'
cp ../../ethercon.ngc results/

#  Copy the constraints files generated by Coregen
echo 'Copying files from constraints directory to results directory'
cp ../example_design/ethercon_example_design.ucf results/

cd results
echo 'Running ngdbuild'
ngdbuild ethercon_example_design

echo 'Running map'
map -ol high -pr b -timing ethercon_example_design -o mapped.ncd

echo 'Running par'
par -ol high -w mapped.ncd routed.ncd mapped.pcf

echo 'Running trce'
trce -u -e 10 routed -o routed mapped.pcf

echo 'Running design through bitgen'
bitgen -w routed.ncd routed mapped.pcf

echo 'Running netgen to create gate level VHDL model'
netgen -ofmt vhdl -pcf mapped.pcf -sim -dir . -tm ethercon_example_design -w routed.ncd routed.vhd

