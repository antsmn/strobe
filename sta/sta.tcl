set sta_report_default_digits 3

foreach file $::env(TECH_LIB) {
    read_liberty $file
}
set_cmd_units -time ns -capacitance fF -current uA -voltage V -resistance kOhm -distance um

read_verilog $::env(VLOG_FILES)
link_design  $::env(VLOG_TOP)
read_sdc sta.sdc

write_sdf $::env(VLOG_TOP).sdf

report_checks -field {fanout cap}

# report_checks
# report_power
