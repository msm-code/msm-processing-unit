run:
	ghdl -a Registers.vhdl
	ghdl -a RegistersTest.vhdl
	ghdl -e RegistersTest
	ghdl -r RegistersTest --stop-time=100ns --vcd=out.wvf

run2:
	ls *.vhdl | xargs -l ghdl -a
	ghdl -e ControlTest
	ghdl -r ControlTest --stop-time=100ns --vcd=out.wvf

clean:
	rm -f *.o
	rm -f *.cc
	rm -f *.cf
	rm -f *.wvf
