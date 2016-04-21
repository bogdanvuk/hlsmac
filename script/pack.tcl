
create_project -force ip_packing ../prj/ip_packing -part "xc7k325tffg900-2"
cd ../ip/hlsmac

set sources [list \
                 ./hdl/receive.vhd \
                 ./hdl/receive_pipeline_Array_dv_V.vhd \
                 ./hdl/receive_pipeline_Array_rxd_V.vhd \
                 ./hdl/transmit_crc32.vhd \
                 ./hdl/transmit.vhd \
                 ./hdl/axi_lite_axi_lite_bus_s_axi.vhd \
                 ./hdl/axi_lite.vhd \
                 ./hdl/mac_top.vhd \
                ]
add_files -norecurse -quiet [join $sources " "]
update_compile_order
ipx::package_project -force -root_dir .
set_property supported_families {{kintex7} {Pre-Production} {zynq} {Pre-Production}} [ipx::current_core]

ipx::add_bus_interface {m_gmii} [ipx::current_core]
set_property abstraction_type_vlnv {xilinx.com:interface:gmii_rtl:1.0} [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]
set_property bus_type_vlnv {xilinx.com:interface:gmii:1.0} [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]
set_property interface_mode {master} [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]
set_property display_name {m_gmii} [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]
set_property description {GMII Master Interface} [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]
ipx::add_port_map {RX_ER} [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]
set_property physical_name {gmii_er} [ipx::get_port_maps RX_ER -of_objects [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]]
ipx::add_port_map {TX_EN} [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]
set_property physical_name {gmii_tx_en} [ipx::get_port_maps TX_EN -of_objects [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]]
ipx::add_port_map {RXD} [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]
set_property physical_name {gmii_rxd} [ipx::get_port_maps RXD -of_objects [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]]
ipx::add_port_map {RX_DV} [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]
set_property physical_name {gmii_dv} [ipx::get_port_maps RX_DV -of_objects [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]]
ipx::add_port_map {TXD} [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]
set_property physical_name {gmii_txd} [ipx::get_port_maps TXD -of_objects [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]]
ipx::add_port_map {TX_ER} [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]
set_property physical_name {gmii_tx_er} [ipx::get_port_maps TX_ER -of_objects [ipx::get_bus_interfaces m_gmii -of_objects [ipx::current_core]]]

ipx::save_core [ipx::current_core]

close_project

cd ../../script

