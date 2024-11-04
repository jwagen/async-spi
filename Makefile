
SIMCOMPILER := iverilog
SIMULATOR := vvp
SIMCOMPFLAGS := -g 2012


SRCS = $(wildcard *.sv)
TBSRCS = $(filter %_tb.sv, $(SRCS))
MODSRCS = $(filter-out %_tb.sv %_incl.sv, $(SRCS))
VVPS = $(patsubst %.sv,%.vvp,$(TBSRCS))
VCDS = $(patsubst %_tb.sv,%_wave.vcd,$(TBSRCS))


simulate: $(VCDS)


$(VVPS): %.vvp: %.sv $(MODSRCS)
	$(SIMCOMPILER) $(SIMCOMPFLAGS) $^ -o $@

$(VCDS): %_wave.vcd: %_tb.vvp
	$(SIMULATOR) $(SIMFLAGS) $<
clean:
	rm $(wildcard *.vvp) $(wildcard *.vcd)