
library ieee;
use ieee.std_logic_1164.all;

--! @brief Import all component declarations
--use work.example_design_1G_comp.all;

--! @brief Library for instantiating Xilinx primitives.
library unisim;
use unisim.vcomponents.all;

entity tb_so_ip_eth_1G_mac is
end tb_so_ip_eth_1G_mac;

architecture impl of tb_so_ip_eth_1G_mac is

    signal clk_sys_s : std_logic := '1';
    signal rst_s : std_logic := '0';

    signal start_frame_generator            : std_logic;
    
begin

    clk_sys_s <= not clk_sys_s after 5 ns;
    rst_s <= '0', '1' after 10 ns, '0' after 30 ns;
    start_frame_generator <= '1';
    
    wrapper: entity work.tb_mac_block_wrapper
      port map (
        S00_AXIS_ARESETN  => not rst_s,
        clk => clk_sys_s,
        start       => start_frame_generator,
        src_addr    => x"5A5A5A5A5A5A",
        dst_addr_1  => x"DADADADADA01",
        dst_addr_2  => x"DADADADADA02",
        pkg_len_min => x"0030",
        pkg_len_max => x"0030",
        pkg_len_inc => x"01",

        gen_oversized_frames    => '0',
        gen_frames_wrong_length => '0',
        pause_len               => x"0001",
        pause_req => '0',
        pause_val => (others => '0'),
        rst => rst_s
      );


end impl;
