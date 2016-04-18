
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
    --signal rst_s : std_logic := '0';

    --signal start_frame_generator            : std_logic;
    
begin

    clk_sys_s <= not clk_sys_s after 5 ns;
    --rst_s <= '0', '1' after 10 ns, '0' after 30 ns;
    --start_frame_generator <= '1';
    
    wrapper: entity work.so_ip_eth_1G_mac_0_exdes
      port map (
          clk_board_i   => clk_sys_s
      );


end impl;
