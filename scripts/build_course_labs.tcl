set root [file dirname [file dirname [file normalize [info script]]]]
set lab_root [file join $root course_labs]
set common [file join $lab_root common]
set release [file join $root course_output]
set part xc7a200tfbg676-2
set_param general.maxThreads 2
file mkdir [file join $release bit]
file mkdir [file join $release reports]

set specs {
    {1_adder            adder_display             1adder_display            {adder32.v} {}}
    {2_multiply         multiply_display          2multiply_display         {board_multiply.v} {}}
    {3_regfile          regfile_display           3regfile_display          {} {}}
    {4_alu              alu_board_top             4alu_display              {adder32.v} {}}
    {5_inst_rom         inst_rom_display          5inst_rom_display         {} {}}
    {6_single_cycle_cpu single_cycle_cpu_display  6single_cycle_cpu_display {} {}}
    {7_multi_cycle_cpu  multi_cycle_cpu_display   7multi_cycle_cpu_display  {} {}}
    {8_pipeline_cpu     pipeline_cpu_display      8pipeline_cpu_display     {} {}}
    {9_booth            multiply_display          9booth_display            {board_multiply.v} {}}
    {10_wallace         multiply_display          10wallace_display         {board_multiply.v} {LAB_WALLACE}}
    {11_single_cycle_mul single_cycle_cpu_display 11single_cycle_mul_display {} {}}
    {12_data_ram        data_ram_display           12data_ram_display        {} {}}
    {13_digital_logic   digital_logic_display      13bcd_counter_display      {} {}}
}

proc build_lab {spec} {
    global lab_root common release part
    lassign $spec folder top filename dependencies defines
    set design_dir [file join $lab_root $folder]
    set report_dir [file join $release reports]
    set hdl [list [file join $common board_lcd_clock.v]]
    foreach dep $dependencies {
        lappend hdl [file join $common $dep]
    }
    foreach source [lsort [glob -directory $design_dir *.v]] {
        lappend hdl $source
    }
    puts "COURSE START $folder"
    set lcd [file join $common lcd_module.dcp]
    set xdc [file join $design_dir board.xdc]
    set checkpoint_dir [file join $release checkpoints]
    file mkdir $checkpoint_dir
    set synthesized [file join $checkpoint_dir [format "%s_synth.dcp" $filename]]
    create_project -in_memory -part $part
    set_param synth.vivado.isSynthRun true
    add_files -quiet $lcd
    set_property used_in_implementation false [get_files $lcd]
    read_verilog $hdl
    read_xdc $xdc
    set_property used_in_implementation false [get_files $xdc]
    set synth_args [list -top $top -part $part -flatten_hierarchy rebuilt]
    if {[llength $defines]} {
        lappend synth_args -verilog_define $defines
    }
    synth_design {*}$synth_args
    write_checkpoint -force -noxdef $synthesized
    close_project

    create_project -in_memory -part $part
    set_param synth.vivado.isSynthRun false
    set_property design_mode GateLvl [current_fileset]
    add_files -quiet [list $synthesized $lcd]
    read_xdc $xdc
    link_design -top $top -part $part
    set draw_clk_out [get_pins -quiet u_lcd/clk_2_reg/Q]
    set draw_clk_in [get_pins -quiet u_lcd/clk_2_reg/C]
    if {[llength $draw_clk_out] == 1 && [llength $draw_clk_in] == 1} {
        create_generated_clock -name lcd_draw_clk -source $draw_clk_in -divide_by 2 $draw_clk_out
    }
    opt_design
    place_design
    phys_opt_design
    route_design
    report_drc -file [file join $report_dir [format "%s_drc.rpt" $filename]]
    report_utilization -file [file join $report_dir [format "%s_utilization.rpt" $filename]]
    report_timing_summary -file [file join $report_dir [format "%s_timing.rpt" $filename]]
    write_bitstream -force [file join $release bit [format "%s.bit" $filename]]
    close_project
    puts "COURSE PASS $folder $filename.bit"
}

set status_path [file join $release build_status.tsv]
set mode [expr {[llength $argv] ? "a" : "w"}]
set status [open $status_path $mode]
set failed {}
set built 0
foreach spec $specs {
    set id [lindex $spec 0]
    if {[llength $argv] && $id ni $argv} { continue }
    if {[catch {build_lab $spec} reason options]} {
        lappend failed $id
        puts $status "$id\tFAIL\t$reason"
        puts "COURSE FAIL $id $reason"
        puts [dict get $options -errorinfo]
        catch {close_project}
    } else {
        puts $status "$id\tPASS\t[lindex $spec 2].bit"
        incr built
    }
    flush $status
}
close $status
puts "COURSE FINISHED, built=$built failed=$failed"
if {[llength $failed] || !$built} { exit 1 }
