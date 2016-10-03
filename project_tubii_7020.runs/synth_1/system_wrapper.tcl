# 
# Synthesis run script generated by Vivado
# 

  set_param gui.test TreeTableDev
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7z020clg400-1
set_property target_language VHDL [current_project]
set_property board em.avnet.com:zynq:microzed:e [current_project]
set_param project.compositeFile.enableAutoGeneration 0
set_property ip_repo_paths {
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/triggers_2.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/triggers_2.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/triggers_2.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/triggers_2.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/prescaleSignal_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/sync_gtid_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/SyncGTID_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/triggers_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/tubii_triggers_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/tubii_triggers_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/ShiftRegisters_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/ShiftRegisters_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/buttonTrigger_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/ShiftReg_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/implement_gtid_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/TrigWordDelay_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/oneshot_pulse_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/fifo_readout_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/counter_1.0
  C:/Users/Ian/project_tubii_7020/ShiftRegs_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/countDisplay_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/comboTrigger_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/testPulser_1.0
  C:/Users/Ian/project_tubii_7020/triggerOut_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/clockLogic_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/triggerSplit_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/testDelay_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/prescaleTrigger_1.0
  C:/Users/Ian/Documents/GitHub/project_tubii_7020/burstTrigger_1.0
} [current_fileset]

add_files C:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/system.bd
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_processing_system7_0_0/system_processing_system7_0_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_xbar_0/system_xbar_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_fifo_generator_0_0/system_fifo_generator_0_0/system_fifo_generator_0_0_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_fifo_generator_0_0/system_fifo_generator_0_0/system_fifo_generator_0_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_fifo_generator_0_0/system_fifo_generator_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_5_0/system_auto_cc_5_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_5_0/system_auto_cc_5_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_xadc_wiz_0_0/system_xadc_wiz_0_0_OOC.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_xadc_wiz_0_0/system_xadc_wiz_0_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_613/system_auto_cc_613_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_613/system_auto_cc_613_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_tier2_xbar_0_1451/system_tier2_xbar_0_1451_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_tier2_xbar_1_1452/system_tier2_xbar_1_1452_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_tier2_xbar_2_1453/system_tier2_xbar_2_1453_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_644/system_auto_cc_644_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_644/system_auto_cc_644_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_645/system_auto_cc_645_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_645/system_auto_cc_645_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_646/system_auto_cc_646_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_646/system_auto_cc_646_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_647/system_auto_cc_647_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_647/system_auto_cc_647_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_648/system_auto_cc_648_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_648/system_auto_cc_648_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_649/system_auto_cc_649_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_cc_649/system_auto_cc_649_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/ip/system_auto_pc_123/system_auto_pc_123_ooc.xdc]
set_property used_in_implementation false [get_files -all C:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/system_ooc.xdc]
set_msg_config -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property is_locked true [get_files C:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/system.bd]

read_vhdl C:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/sources_1/bd/system/hdl/system_wrapper.vhd
read_xdc C:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/constrs_1/new/constraints.xdc
set_property used_in_implementation false [get_files C:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.srcs/constrs_1/new/constraints.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/Ian/Documents/GitHub/project_tubii_7020/project_tubii_7020.data/wt [current_project]
set_property parent.project_dir C:/Users/Ian/Documents/GitHub/project_tubii_7020 [current_project]
synth_design -top system_wrapper -part xc7z020clg400-1
write_checkpoint system_wrapper.dcp
report_utilization -file system_wrapper_utilization_synth.rpt -pb system_wrapper_utilization_synth.pb
