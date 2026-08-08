
SRC_DIR            = ../src
export SRC_DIR

VLOG_TB            ?=
VLOG_TOP           ?=

VLOG_FLAGS         ?=
VLOG_FLIST         ?=

VLOG_DEFAULT_FLAGS =-g2012 -Wall -Wno-timescale
VLOG               = iverilog $(VLOG_DEFAULT_FLAGS)
VSIM		   = vvp -n

run: $(VLOG_TOP).vvp
	@$(VSIM) $< -vcd-none

vcd: $(VLOG_TOP).vvp
	@$(VSIM) $< -vcd

$(VLOG_TOP).vvp:
	@$(VLOG) $(VLOG_FLAGS) \
	-f $(VLOG_FLIST)       \
	-o $@ -s $(VLOG_TOP)

# $(VLOG_TOP).vvp: $(VLOG_TB) $(VLOG_FILES)
#         @$(VLOG) $(VLOG_FLAGS) \
#         -s $(VLOG_TOP) -o $@   \
#         $(VLOG_TB) $(VLOG_FILES)

clean:
	@rm -f *.vvp
	@rm -f *.vcd
