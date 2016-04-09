#*******************************************************************************
# Create a project
open_project -reset hlsmac

# Add design files
add_files mac.cpp
add_files mac.hpp
# Add test bench & files
add_files -tb hlsmac_test.cpp

# Set the top-level function
set_top mac

# ########################################################
# Create a solution
open_solution -reset solution1
set_part {xc7k325tffg900-2}
create_clock -period 25MHz -name default
cosim_design -trace_level all -tool xsim

