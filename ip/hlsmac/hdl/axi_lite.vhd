-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2015.4
-- Copyright (C) 2015 Xilinx Inc. All rights reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity axi_lite is
generic (
    C_S_AXI_AXI_LITE_BUS_ADDR_WIDTH : INTEGER := 11;
    C_S_AXI_AXI_LITE_BUS_DATA_WIDTH : INTEGER := 32 );
port (
    ap_clk : IN STD_LOGIC;
    ap_rst_n : IN STD_LOGIC;
    tx_status_V_dout : IN STD_LOGIC_VECTOR (19 downto 0);
    tx_status_V_empty_n : IN STD_LOGIC;
    tx_status_V_read : OUT STD_LOGIC;
    rx_status_V_dout : IN STD_LOGIC_VECTOR (22 downto 0);
    rx_status_V_empty_n : IN STD_LOGIC;
    rx_status_V_read : OUT STD_LOGIC;
    s_axi_axi_lite_bus_AWVALID : IN STD_LOGIC;
    s_axi_axi_lite_bus_AWREADY : OUT STD_LOGIC;
    s_axi_axi_lite_bus_AWADDR : IN STD_LOGIC_VECTOR (C_S_AXI_AXI_LITE_BUS_ADDR_WIDTH-1 downto 0);
    s_axi_axi_lite_bus_WVALID : IN STD_LOGIC;
    s_axi_axi_lite_bus_WREADY : OUT STD_LOGIC;
    s_axi_axi_lite_bus_WDATA : IN STD_LOGIC_VECTOR (C_S_AXI_AXI_LITE_BUS_DATA_WIDTH-1 downto 0);
    s_axi_axi_lite_bus_WSTRB : IN STD_LOGIC_VECTOR (C_S_AXI_AXI_LITE_BUS_DATA_WIDTH/8-1 downto 0);
    s_axi_axi_lite_bus_ARVALID : IN STD_LOGIC;
    s_axi_axi_lite_bus_ARREADY : OUT STD_LOGIC;
    s_axi_axi_lite_bus_ARADDR : IN STD_LOGIC_VECTOR (C_S_AXI_AXI_LITE_BUS_ADDR_WIDTH-1 downto 0);
    s_axi_axi_lite_bus_RVALID : OUT STD_LOGIC;
    s_axi_axi_lite_bus_RREADY : IN STD_LOGIC;
    s_axi_axi_lite_bus_RDATA : OUT STD_LOGIC_VECTOR (C_S_AXI_AXI_LITE_BUS_DATA_WIDTH-1 downto 0);
    s_axi_axi_lite_bus_RRESP : OUT STD_LOGIC_VECTOR (1 downto 0);
    s_axi_axi_lite_bus_BVALID : OUT STD_LOGIC;
    s_axi_axi_lite_bus_BREADY : IN STD_LOGIC;
    s_axi_axi_lite_bus_BRESP : OUT STD_LOGIC_VECTOR (1 downto 0) );
end;


architecture behav of axi_lite is 
    attribute CORE_GENERATION_INFO : STRING;
    attribute CORE_GENERATION_INFO of behav : architecture is
    "axi_lite,hls_ip_2015_4,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7k325tffg900-2,HLS_INPUT_CLOCK=40.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=4.631000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=1120,HLS_SYN_LUT=1577}";
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_st1_fsm_0 : STD_LOGIC_VECTOR (1 downto 0) := "01";
    constant ap_ST_st2_fsm_1 : STD_LOGIC_VECTOR (1 downto 0) := "10";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant C_S_AXI_DATA_WIDTH : INTEGER range 63 downto 0 := 20;
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv14_40 : STD_LOGIC_VECTOR (13 downto 0) := "00000001000000";
    constant ap_const_lv32_7 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000111";
    constant ap_const_lv32_D : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001101";
    constant ap_const_lv7_0 : STD_LOGIC_VECTOR (6 downto 0) := "0000000";
    constant ap_const_lv32_8 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001000";
    constant ap_const_lv6_0 : STD_LOGIC_VECTOR (5 downto 0) := "000000";
    constant ap_const_lv32_9 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001001";
    constant ap_const_lv5_0 : STD_LOGIC_VECTOR (4 downto 0) := "00000";
    constant ap_const_lv32_A : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001010";
    constant ap_const_lv4_0 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    constant ap_const_lv32_E : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001110";
    constant ap_const_lv14_0 : STD_LOGIC_VECTOR (13 downto 0) := "00000000000000";

    signal ap_rst_n_inv : STD_LOGIC;
    signal rx_bytes_V : STD_LOGIC_VECTOR (31 downto 0);
    signal rx_64_V : STD_LOGIC_VECTOR (31 downto 0);
    signal rx_65_127_V : STD_LOGIC_VECTOR (31 downto 0);
    signal rx_128_255_V : STD_LOGIC_VECTOR (31 downto 0);
    signal rx_256_511_V : STD_LOGIC_VECTOR (31 downto 0);
    signal rx_512_1023_V : STD_LOGIC_VECTOR (31 downto 0);
    signal rx_1024_max_V : STD_LOGIC_VECTOR (31 downto 0);
    signal tx_64_V : STD_LOGIC_VECTOR (31 downto 0);
    signal tx_65_127_V : STD_LOGIC_VECTOR (31 downto 0);
    signal tx_128_255_V : STD_LOGIC_VECTOR (31 downto 0);
    signal tx_256_511_V : STD_LOGIC_VECTOR (31 downto 0);
    signal tx_512_1023_V : STD_LOGIC_VECTOR (31 downto 0);
    signal tx_1024_max_V : STD_LOGIC_VECTOR (31 downto 0);
    signal rx_good_V : STD_LOGIC_VECTOR (31 downto 0);
    signal reg_rx_bytes_V : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal reg_rx_64_V : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal reg_rx_65_127_V : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal reg_rx_128_255_V : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal reg_rx_256_511_V : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal reg_rx_512_1023_V : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal reg_rx_1024_max_V : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal reg_tx_64_V : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal reg_tx_65_127_V : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal reg_tx_128_255_V : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal reg_tx_256_511_V : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal reg_tx_512_1023_V : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal reg_tx_1024_max_V : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal reg_rx_good_V : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal dummy_last_V_i : STD_LOGIC_VECTOR (31 downto 0);
    signal dummy_last_V_o : STD_LOGIC_VECTOR (31 downto 0);
    signal dummy_last_V_o_ap_vld : STD_LOGIC;
    signal axi_lite_axi_lite_bus_s_axi_U_ap_dummy_ce : STD_LOGIC;
    signal ap_CS_fsm : STD_LOGIC_VECTOR (1 downto 0) := "01";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_sig_cseq_ST_st2_fsm_1 : STD_LOGIC;
    signal ap_sig_bdd_94 : BOOLEAN;
    signal tx_stat_avail_phi_fu_309_p4 : STD_LOGIC_VECTOR (0 downto 0);
    signal tx_stat_avail_reg_305 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal ap_sig_cseq_ST_st1_fsm_0 : STD_LOGIC;
    signal ap_sig_bdd_106 : BOOLEAN;
    signal rx_stat_avail_phi_fu_320_p4 : STD_LOGIC_VECTOR (0 downto 0);
    signal rx_stat_avail_reg_316 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal tx_status_V_read_nbread_fu_293_p2_0 : STD_LOGIC_VECTOR (0 downto 0);
    signal rx_status_V_read_nbread_fu_299_p2_0 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_12_fu_579_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal rx_din_good_V_load_load_fu_557_p1 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_14_fu_733_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal tmp_13_fu_591_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_16_fu_721_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal icmp2_fu_610_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_18_fu_709_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal icmp3_fu_629_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_20_fu_697_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal icmp5_fu_648_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_22_fu_685_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal icmp6_fu_667_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_23_fu_673_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal tmp_1_fu_545_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal tx_din_good_V_load_load_fu_397_p1 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_fu_403_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_3_fu_533_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal icmp_fu_422_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_5_fu_521_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal icmp4_fu_441_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_7_fu_509_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal icmp7_fu_460_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_9_fu_497_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal icmp1_fu_479_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_s_fu_485_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal tmp_10_fu_563_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal tx_din_count_V_fu_166 : STD_LOGIC_VECTOR (13 downto 0) := "00000000000000";
    signal tx_din_count_V_1_fu_760_p1 : STD_LOGIC_VECTOR (13 downto 0);
    signal tx_din_good_V_fu_170 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal rx_din_good_V_fu_174 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal rx_din_count_V_fu_178 : STD_LOGIC_VECTOR (13 downto 0) := "00000000000000";
    signal rx_din_count_V_1_fu_780_p1 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_2_fu_412_p4 : STD_LOGIC_VECTOR (6 downto 0);
    signal tmp_4_fu_431_p4 : STD_LOGIC_VECTOR (5 downto 0);
    signal tmp_6_fu_450_p4 : STD_LOGIC_VECTOR (4 downto 0);
    signal tmp_8_fu_469_p4 : STD_LOGIC_VECTOR (3 downto 0);
    signal tmp_11_fu_575_p1 : STD_LOGIC_VECTOR (31 downto 0);
    signal tmp_15_fu_600_p4 : STD_LOGIC_VECTOR (6 downto 0);
    signal tmp_17_fu_619_p4 : STD_LOGIC_VECTOR (5 downto 0);
    signal tmp_19_fu_638_p4 : STD_LOGIC_VECTOR (4 downto 0);
    signal tmp_21_fu_657_p4 : STD_LOGIC_VECTOR (3 downto 0);
    signal ap_NS_fsm : STD_LOGIC_VECTOR (1 downto 0);

    component axi_lite_axi_lite_bus_s_axi IS
    generic (
        C_S_AXI_ADDR_WIDTH : INTEGER;
        C_S_AXI_DATA_WIDTH : INTEGER );
    port (
        AWVALID : IN STD_LOGIC;
        AWREADY : OUT STD_LOGIC;
        AWADDR : IN STD_LOGIC_VECTOR (C_S_AXI_ADDR_WIDTH-1 downto 0);
        WVALID : IN STD_LOGIC;
        WREADY : OUT STD_LOGIC;
        WDATA : IN STD_LOGIC_VECTOR (C_S_AXI_DATA_WIDTH-1 downto 0);
        WSTRB : IN STD_LOGIC_VECTOR (C_S_AXI_DATA_WIDTH/8-1 downto 0);
        ARVALID : IN STD_LOGIC;
        ARREADY : OUT STD_LOGIC;
        ARADDR : IN STD_LOGIC_VECTOR (C_S_AXI_ADDR_WIDTH-1 downto 0);
        RVALID : OUT STD_LOGIC;
        RREADY : IN STD_LOGIC;
        RDATA : OUT STD_LOGIC_VECTOR (C_S_AXI_DATA_WIDTH-1 downto 0);
        RRESP : OUT STD_LOGIC_VECTOR (1 downto 0);
        BVALID : OUT STD_LOGIC;
        BREADY : IN STD_LOGIC;
        BRESP : OUT STD_LOGIC_VECTOR (1 downto 0);
        ACLK : IN STD_LOGIC;
        ARESET : IN STD_LOGIC;
        ACLK_EN : IN STD_LOGIC;
        rx_bytes_V : IN STD_LOGIC_VECTOR (31 downto 0);
        rx_64_V : IN STD_LOGIC_VECTOR (31 downto 0);
        rx_65_127_V : IN STD_LOGIC_VECTOR (31 downto 0);
        rx_128_255_V : IN STD_LOGIC_VECTOR (31 downto 0);
        rx_256_511_V : IN STD_LOGIC_VECTOR (31 downto 0);
        rx_512_1023_V : IN STD_LOGIC_VECTOR (31 downto 0);
        rx_1024_max_V : IN STD_LOGIC_VECTOR (31 downto 0);
        tx_64_V : IN STD_LOGIC_VECTOR (31 downto 0);
        tx_65_127_V : IN STD_LOGIC_VECTOR (31 downto 0);
        tx_128_255_V : IN STD_LOGIC_VECTOR (31 downto 0);
        tx_256_511_V : IN STD_LOGIC_VECTOR (31 downto 0);
        tx_512_1023_V : IN STD_LOGIC_VECTOR (31 downto 0);
        tx_1024_max_V : IN STD_LOGIC_VECTOR (31 downto 0);
        rx_good_V : IN STD_LOGIC_VECTOR (31 downto 0);
        dummy_last_V_o : IN STD_LOGIC_VECTOR (31 downto 0);
        dummy_last_V_o_ap_vld : IN STD_LOGIC;
        dummy_last_V_i : OUT STD_LOGIC_VECTOR (31 downto 0) );
    end component;



begin
    axi_lite_axi_lite_bus_s_axi_U : component axi_lite_axi_lite_bus_s_axi
    generic map (
        C_S_AXI_ADDR_WIDTH => C_S_AXI_AXI_LITE_BUS_ADDR_WIDTH,
        C_S_AXI_DATA_WIDTH => C_S_AXI_AXI_LITE_BUS_DATA_WIDTH)
    port map (
        AWVALID => s_axi_axi_lite_bus_AWVALID,
        AWREADY => s_axi_axi_lite_bus_AWREADY,
        AWADDR => s_axi_axi_lite_bus_AWADDR,
        WVALID => s_axi_axi_lite_bus_WVALID,
        WREADY => s_axi_axi_lite_bus_WREADY,
        WDATA => s_axi_axi_lite_bus_WDATA,
        WSTRB => s_axi_axi_lite_bus_WSTRB,
        ARVALID => s_axi_axi_lite_bus_ARVALID,
        ARREADY => s_axi_axi_lite_bus_ARREADY,
        ARADDR => s_axi_axi_lite_bus_ARADDR,
        RVALID => s_axi_axi_lite_bus_RVALID,
        RREADY => s_axi_axi_lite_bus_RREADY,
        RDATA => s_axi_axi_lite_bus_RDATA,
        RRESP => s_axi_axi_lite_bus_RRESP,
        BVALID => s_axi_axi_lite_bus_BVALID,
        BREADY => s_axi_axi_lite_bus_BREADY,
        BRESP => s_axi_axi_lite_bus_BRESP,
        ACLK => ap_clk,
        ARESET => ap_rst_n_inv,
        ACLK_EN => axi_lite_axi_lite_bus_s_axi_U_ap_dummy_ce,
        rx_bytes_V => rx_bytes_V,
        rx_64_V => rx_64_V,
        rx_65_127_V => rx_65_127_V,
        rx_128_255_V => rx_128_255_V,
        rx_256_511_V => rx_256_511_V,
        rx_512_1023_V => rx_512_1023_V,
        rx_1024_max_V => rx_1024_max_V,
        tx_64_V => tx_64_V,
        tx_65_127_V => tx_65_127_V,
        tx_128_255_V => tx_128_255_V,
        tx_256_511_V => tx_256_511_V,
        tx_512_1023_V => tx_512_1023_V,
        tx_1024_max_V => tx_1024_max_V,
        rx_good_V => rx_good_V,
        dummy_last_V_o => dummy_last_V_o,
        dummy_last_V_o_ap_vld => dummy_last_V_o_ap_vld,
        dummy_last_V_i => dummy_last_V_i);





    -- the current state (ap_CS_fsm) of the state machine. --
    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                ap_CS_fsm <= ap_ST_st1_fsm_0;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    -- reg_rx_1024_max_V assign process. --
    reg_rx_1024_max_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                reg_rx_1024_max_V <= ap_const_lv32_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((ap_const_lv1_0 = rx_stat_avail_phi_fu_320_p4)) and not((ap_const_lv1_0 = rx_din_good_V_load_load_fu_557_p1)) and (ap_const_lv1_0 = tmp_13_fu_591_p2) and (ap_const_lv1_0 = icmp2_fu_610_p2) and (ap_const_lv1_0 = icmp3_fu_629_p2) and (ap_const_lv1_0 = icmp5_fu_648_p2) and (ap_const_lv1_0 = icmp6_fu_667_p2))) then 
                    reg_rx_1024_max_V <= tmp_23_fu_673_p2;
                end if; 
            end if;
        end if;
    end process;


    -- reg_rx_128_255_V assign process. --
    reg_rx_128_255_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                reg_rx_128_255_V <= ap_const_lv32_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((ap_const_lv1_0 = rx_stat_avail_phi_fu_320_p4)) and not((ap_const_lv1_0 = rx_din_good_V_load_load_fu_557_p1)) and (ap_const_lv1_0 = tmp_13_fu_591_p2) and (ap_const_lv1_0 = icmp2_fu_610_p2) and not((ap_const_lv1_0 = icmp3_fu_629_p2)))) then 
                    reg_rx_128_255_V <= tmp_18_fu_709_p2;
                end if; 
            end if;
        end if;
    end process;


    -- reg_rx_256_511_V assign process. --
    reg_rx_256_511_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                reg_rx_256_511_V <= ap_const_lv32_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((ap_const_lv1_0 = rx_stat_avail_phi_fu_320_p4)) and not((ap_const_lv1_0 = rx_din_good_V_load_load_fu_557_p1)) and (ap_const_lv1_0 = tmp_13_fu_591_p2) and (ap_const_lv1_0 = icmp2_fu_610_p2) and (ap_const_lv1_0 = icmp3_fu_629_p2) and not((ap_const_lv1_0 = icmp5_fu_648_p2)))) then 
                    reg_rx_256_511_V <= tmp_20_fu_697_p2;
                end if; 
            end if;
        end if;
    end process;


    -- reg_rx_512_1023_V assign process. --
    reg_rx_512_1023_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                reg_rx_512_1023_V <= ap_const_lv32_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((ap_const_lv1_0 = rx_stat_avail_phi_fu_320_p4)) and not((ap_const_lv1_0 = rx_din_good_V_load_load_fu_557_p1)) and (ap_const_lv1_0 = tmp_13_fu_591_p2) and (ap_const_lv1_0 = icmp2_fu_610_p2) and (ap_const_lv1_0 = icmp3_fu_629_p2) and (ap_const_lv1_0 = icmp5_fu_648_p2) and not((ap_const_lv1_0 = icmp6_fu_667_p2)))) then 
                    reg_rx_512_1023_V <= tmp_22_fu_685_p2;
                end if; 
            end if;
        end if;
    end process;


    -- reg_rx_64_V assign process. --
    reg_rx_64_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                reg_rx_64_V <= ap_const_lv32_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((ap_const_lv1_0 = rx_stat_avail_phi_fu_320_p4)) and not((ap_const_lv1_0 = rx_din_good_V_load_load_fu_557_p1)) and not((ap_const_lv1_0 = tmp_13_fu_591_p2)))) then 
                    reg_rx_64_V <= tmp_14_fu_733_p2;
                end if; 
            end if;
        end if;
    end process;


    -- reg_rx_65_127_V assign process. --
    reg_rx_65_127_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                reg_rx_65_127_V <= ap_const_lv32_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((ap_const_lv1_0 = rx_stat_avail_phi_fu_320_p4)) and not((ap_const_lv1_0 = rx_din_good_V_load_load_fu_557_p1)) and (ap_const_lv1_0 = tmp_13_fu_591_p2) and not((ap_const_lv1_0 = icmp2_fu_610_p2)))) then 
                    reg_rx_65_127_V <= tmp_16_fu_721_p2;
                end if; 
            end if;
        end if;
    end process;


    -- reg_rx_bytes_V assign process. --
    reg_rx_bytes_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                reg_rx_bytes_V <= ap_const_lv32_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((ap_const_lv1_0 = rx_stat_avail_phi_fu_320_p4)) and not((ap_const_lv1_0 = rx_din_good_V_load_load_fu_557_p1)))) then 
                    reg_rx_bytes_V <= tmp_12_fu_579_p2;
                end if; 
            end if;
        end if;
    end process;


    -- reg_rx_good_V assign process. --
    reg_rx_good_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                reg_rx_good_V <= ap_const_lv32_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((ap_const_lv1_0 = rx_stat_avail_phi_fu_320_p4)) and not((ap_const_lv1_0 = rx_din_good_V_load_load_fu_557_p1)))) then 
                    reg_rx_good_V <= tmp_10_fu_563_p2;
                end if; 
            end if;
        end if;
    end process;


    -- reg_tx_1024_max_V assign process. --
    reg_tx_1024_max_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                reg_tx_1024_max_V <= ap_const_lv32_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((ap_const_lv1_0 = tx_stat_avail_phi_fu_309_p4)) and not((ap_const_lv1_0 = tx_din_good_V_load_load_fu_397_p1)) and (ap_const_lv1_0 = tmp_fu_403_p2) and (ap_const_lv1_0 = icmp_fu_422_p2) and (ap_const_lv1_0 = icmp4_fu_441_p2) and (ap_const_lv1_0 = icmp7_fu_460_p2) and (ap_const_lv1_0 = icmp1_fu_479_p2))) then 
                    reg_tx_1024_max_V <= tmp_s_fu_485_p2;
                end if; 
            end if;
        end if;
    end process;


    -- reg_tx_128_255_V assign process. --
    reg_tx_128_255_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                reg_tx_128_255_V <= ap_const_lv32_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((ap_const_lv1_0 = tx_stat_avail_phi_fu_309_p4)) and not((ap_const_lv1_0 = tx_din_good_V_load_load_fu_397_p1)) and (ap_const_lv1_0 = tmp_fu_403_p2) and (ap_const_lv1_0 = icmp_fu_422_p2) and not((ap_const_lv1_0 = icmp4_fu_441_p2)))) then 
                    reg_tx_128_255_V <= tmp_5_fu_521_p2;
                end if; 
            end if;
        end if;
    end process;


    -- reg_tx_256_511_V assign process. --
    reg_tx_256_511_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                reg_tx_256_511_V <= ap_const_lv32_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((ap_const_lv1_0 = tx_stat_avail_phi_fu_309_p4)) and not((ap_const_lv1_0 = tx_din_good_V_load_load_fu_397_p1)) and (ap_const_lv1_0 = tmp_fu_403_p2) and (ap_const_lv1_0 = icmp_fu_422_p2) and (ap_const_lv1_0 = icmp4_fu_441_p2) and not((ap_const_lv1_0 = icmp7_fu_460_p2)))) then 
                    reg_tx_256_511_V <= tmp_7_fu_509_p2;
                end if; 
            end if;
        end if;
    end process;


    -- reg_tx_512_1023_V assign process. --
    reg_tx_512_1023_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                reg_tx_512_1023_V <= ap_const_lv32_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((ap_const_lv1_0 = tx_stat_avail_phi_fu_309_p4)) and not((ap_const_lv1_0 = tx_din_good_V_load_load_fu_397_p1)) and (ap_const_lv1_0 = tmp_fu_403_p2) and (ap_const_lv1_0 = icmp_fu_422_p2) and (ap_const_lv1_0 = icmp4_fu_441_p2) and (ap_const_lv1_0 = icmp7_fu_460_p2) and not((ap_const_lv1_0 = icmp1_fu_479_p2)))) then 
                    reg_tx_512_1023_V <= tmp_9_fu_497_p2;
                end if; 
            end if;
        end if;
    end process;


    -- reg_tx_64_V assign process. --
    reg_tx_64_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                reg_tx_64_V <= ap_const_lv32_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((ap_const_lv1_0 = tx_stat_avail_phi_fu_309_p4)) and not((ap_const_lv1_0 = tx_din_good_V_load_load_fu_397_p1)) and not((ap_const_lv1_0 = tmp_fu_403_p2)))) then 
                    reg_tx_64_V <= tmp_1_fu_545_p2;
                end if; 
            end if;
        end if;
    end process;


    -- reg_tx_65_127_V assign process. --
    reg_tx_65_127_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                reg_tx_65_127_V <= ap_const_lv32_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((ap_const_lv1_0 = tx_stat_avail_phi_fu_309_p4)) and not((ap_const_lv1_0 = tx_din_good_V_load_load_fu_397_p1)) and (ap_const_lv1_0 = tmp_fu_403_p2) and not((ap_const_lv1_0 = icmp_fu_422_p2)))) then 
                    reg_tx_65_127_V <= tmp_3_fu_533_p2;
                end if; 
            end if;
        end if;
    end process;


    -- rx_din_count_V_fu_178 assign process. --
    rx_din_count_V_fu_178_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                rx_din_count_V_fu_178 <= ap_const_lv14_0;
            else
                if ((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1)) then 
                    rx_din_count_V_fu_178 <= rx_din_count_V_1_fu_780_p1;
                end if; 
            end if;
        end if;
    end process;


    -- rx_din_good_V_fu_174 assign process. --
    rx_din_good_V_fu_174_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                rx_din_good_V_fu_174 <= ap_const_lv1_0;
            else
                if ((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1)) then 
                    rx_din_good_V_fu_174 <= rx_status_V_dout(14 downto 14);
                end if; 
            end if;
        end if;
    end process;


    -- rx_stat_avail_reg_316 assign process. --
    rx_stat_avail_reg_316_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                rx_stat_avail_reg_316 <= ap_const_lv1_0;
            else
                if ((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1)) then 
                    rx_stat_avail_reg_316 <= rx_status_V_read_nbread_fu_299_p2_0;
                elsif ((ap_const_logic_1 = ap_sig_cseq_ST_st1_fsm_0)) then 
                    rx_stat_avail_reg_316 <= ap_const_lv1_0;
                end if; 
            end if;
        end if;
    end process;


    -- tx_din_count_V_fu_166 assign process. --
    tx_din_count_V_fu_166_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                tx_din_count_V_fu_166 <= ap_const_lv14_0;
            else
                if ((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1)) then 
                    tx_din_count_V_fu_166 <= tx_din_count_V_1_fu_760_p1;
                end if; 
            end if;
        end if;
    end process;


    -- tx_din_good_V_fu_170 assign process. --
    tx_din_good_V_fu_170_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                tx_din_good_V_fu_170 <= ap_const_lv1_0;
            else
                if ((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1)) then 
                    tx_din_good_V_fu_170 <= tx_status_V_dout(14 downto 14);
                end if; 
            end if;
        end if;
    end process;


    -- tx_stat_avail_reg_305 assign process. --
    tx_stat_avail_reg_305_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                tx_stat_avail_reg_305 <= ap_const_lv1_0;
            else
                if ((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1)) then 
                    tx_stat_avail_reg_305 <= tx_status_V_read_nbread_fu_293_p2_0;
                elsif ((ap_const_logic_1 = ap_sig_cseq_ST_st1_fsm_0)) then 
                    tx_stat_avail_reg_305 <= ap_const_lv1_0;
                end if; 
            end if;
        end if;
    end process;


    -- the next state (ap_NS_fsm) of the state machine. --
    ap_NS_fsm_assign_proc : process (ap_CS_fsm)
    begin
        case ap_CS_fsm is
            when ap_ST_st1_fsm_0 => 
                ap_NS_fsm <= ap_ST_st2_fsm_1;
            when ap_ST_st2_fsm_1 => 
                ap_NS_fsm <= ap_ST_st2_fsm_1;
            when others =>  
                ap_NS_fsm <= "XX";
        end case;
    end process;

    -- ap_rst_n_inv assign process. --
    ap_rst_n_inv_assign_proc : process(ap_rst_n)
    begin
                ap_rst_n_inv <= not(ap_rst_n);
    end process;


    -- ap_sig_bdd_106 assign process. --
    ap_sig_bdd_106_assign_proc : process(ap_CS_fsm)
    begin
                ap_sig_bdd_106 <= (ap_const_lv1_1 = ap_CS_fsm(0 downto 0));
    end process;


    -- ap_sig_bdd_94 assign process. --
    ap_sig_bdd_94_assign_proc : process(ap_CS_fsm)
    begin
                ap_sig_bdd_94 <= (ap_CS_fsm(1 downto 1) = ap_const_lv1_1);
    end process;


    -- ap_sig_cseq_ST_st1_fsm_0 assign process. --
    ap_sig_cseq_ST_st1_fsm_0_assign_proc : process(ap_sig_bdd_106)
    begin
        if (ap_sig_bdd_106) then 
            ap_sig_cseq_ST_st1_fsm_0 <= ap_const_logic_1;
        else 
            ap_sig_cseq_ST_st1_fsm_0 <= ap_const_logic_0;
        end if; 
    end process;


    -- ap_sig_cseq_ST_st2_fsm_1 assign process. --
    ap_sig_cseq_ST_st2_fsm_1_assign_proc : process(ap_sig_bdd_94)
    begin
        if (ap_sig_bdd_94) then 
            ap_sig_cseq_ST_st2_fsm_1 <= ap_const_logic_1;
        else 
            ap_sig_cseq_ST_st2_fsm_1 <= ap_const_logic_0;
        end if; 
    end process;

    axi_lite_axi_lite_bus_s_axi_U_ap_dummy_ce <= ap_const_logic_1;
    dummy_last_V_o <= std_logic_vector(unsigned(dummy_last_V_i) + unsigned(ap_const_lv32_1));

    -- dummy_last_V_o_ap_vld assign process. --
    dummy_last_V_o_ap_vld_assign_proc : process(ap_sig_cseq_ST_st2_fsm_1, rx_stat_avail_phi_fu_320_p4, rx_din_good_V_load_load_fu_557_p1)
    begin
        if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((ap_const_lv1_0 = rx_stat_avail_phi_fu_320_p4)) and not((ap_const_lv1_0 = rx_din_good_V_load_load_fu_557_p1)))) then 
            dummy_last_V_o_ap_vld <= ap_const_logic_1;
        else 
            dummy_last_V_o_ap_vld <= ap_const_logic_0;
        end if; 
    end process;

    icmp1_fu_479_p2 <= "1" when (tmp_8_fu_469_p4 = ap_const_lv4_0) else "0";
    icmp2_fu_610_p2 <= "1" when (tmp_15_fu_600_p4 = ap_const_lv7_0) else "0";
    icmp3_fu_629_p2 <= "1" when (tmp_17_fu_619_p4 = ap_const_lv6_0) else "0";
    icmp4_fu_441_p2 <= "1" when (tmp_4_fu_431_p4 = ap_const_lv6_0) else "0";
    icmp5_fu_648_p2 <= "1" when (tmp_19_fu_638_p4 = ap_const_lv5_0) else "0";
    icmp6_fu_667_p2 <= "1" when (tmp_21_fu_657_p4 = ap_const_lv4_0) else "0";
    icmp7_fu_460_p2 <= "1" when (tmp_6_fu_450_p4 = ap_const_lv5_0) else "0";
    icmp_fu_422_p2 <= "1" when (tmp_2_fu_412_p4 = ap_const_lv7_0) else "0";
    rx_1024_max_V <= reg_rx_1024_max_V;
    rx_128_255_V <= reg_rx_128_255_V;
    rx_256_511_V <= reg_rx_256_511_V;
    rx_512_1023_V <= reg_rx_512_1023_V;
    rx_64_V <= reg_rx_64_V;
    rx_65_127_V <= reg_rx_65_127_V;
    rx_bytes_V <= reg_rx_bytes_V;
    rx_din_count_V_1_fu_780_p1 <= rx_status_V_dout(14 - 1 downto 0);
    rx_din_good_V_load_load_fu_557_p1 <= rx_din_good_V_fu_174;
    rx_good_V <= reg_rx_good_V;
    rx_stat_avail_phi_fu_320_p4 <= rx_stat_avail_reg_316;

    -- rx_status_V_read assign process. --
    rx_status_V_read_assign_proc : process(rx_status_V_empty_n, ap_sig_cseq_ST_st2_fsm_1)
    begin
        if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and (ap_const_logic_1 = rx_status_V_empty_n))) then 
            rx_status_V_read <= ap_const_logic_1;
        else 
            rx_status_V_read <= ap_const_logic_0;
        end if; 
    end process;

    rx_status_V_read_nbread_fu_299_p2_0 <= (0=>rx_status_V_empty_n, others=>'-');
    tmp_10_fu_563_p2 <= std_logic_vector(unsigned(reg_rx_good_V) + unsigned(ap_const_lv32_1));
    tmp_11_fu_575_p1 <= std_logic_vector(resize(unsigned(rx_din_count_V_fu_178),32));
    tmp_12_fu_579_p2 <= std_logic_vector(unsigned(reg_rx_bytes_V) + unsigned(tmp_11_fu_575_p1));
    tmp_13_fu_591_p2 <= "1" when (rx_din_count_V_fu_178 = ap_const_lv14_40) else "0";
    tmp_14_fu_733_p2 <= std_logic_vector(unsigned(reg_rx_64_V) + unsigned(ap_const_lv32_1));
    tmp_15_fu_600_p4 <= rx_din_count_V_fu_178(13 downto 7);
    tmp_16_fu_721_p2 <= std_logic_vector(unsigned(reg_rx_65_127_V) + unsigned(ap_const_lv32_1));
    tmp_17_fu_619_p4 <= rx_din_count_V_fu_178(13 downto 8);
    tmp_18_fu_709_p2 <= std_logic_vector(unsigned(reg_rx_128_255_V) + unsigned(ap_const_lv32_1));
    tmp_19_fu_638_p4 <= rx_din_count_V_fu_178(13 downto 9);
    tmp_1_fu_545_p2 <= std_logic_vector(unsigned(reg_tx_64_V) + unsigned(ap_const_lv32_1));
    tmp_20_fu_697_p2 <= std_logic_vector(unsigned(reg_rx_256_511_V) + unsigned(ap_const_lv32_1));
    tmp_21_fu_657_p4 <= rx_din_count_V_fu_178(13 downto 10);
    tmp_22_fu_685_p2 <= std_logic_vector(unsigned(reg_rx_512_1023_V) + unsigned(ap_const_lv32_1));
    tmp_23_fu_673_p2 <= std_logic_vector(unsigned(reg_rx_1024_max_V) + unsigned(ap_const_lv32_1));
    tmp_2_fu_412_p4 <= tx_din_count_V_fu_166(13 downto 7);
    tmp_3_fu_533_p2 <= std_logic_vector(unsigned(reg_tx_65_127_V) + unsigned(ap_const_lv32_1));
    tmp_4_fu_431_p4 <= tx_din_count_V_fu_166(13 downto 8);
    tmp_5_fu_521_p2 <= std_logic_vector(unsigned(reg_tx_128_255_V) + unsigned(ap_const_lv32_1));
    tmp_6_fu_450_p4 <= tx_din_count_V_fu_166(13 downto 9);
    tmp_7_fu_509_p2 <= std_logic_vector(unsigned(reg_tx_256_511_V) + unsigned(ap_const_lv32_1));
    tmp_8_fu_469_p4 <= tx_din_count_V_fu_166(13 downto 10);
    tmp_9_fu_497_p2 <= std_logic_vector(unsigned(reg_tx_512_1023_V) + unsigned(ap_const_lv32_1));
    tmp_fu_403_p2 <= "1" when (tx_din_count_V_fu_166 = ap_const_lv14_40) else "0";
    tmp_s_fu_485_p2 <= std_logic_vector(unsigned(reg_tx_1024_max_V) + unsigned(ap_const_lv32_1));
    tx_1024_max_V <= reg_tx_1024_max_V;
    tx_128_255_V <= reg_tx_128_255_V;
    tx_256_511_V <= reg_tx_256_511_V;
    tx_512_1023_V <= reg_tx_512_1023_V;
    tx_64_V <= reg_tx_64_V;
    tx_65_127_V <= reg_tx_65_127_V;
    tx_din_count_V_1_fu_760_p1 <= tx_status_V_dout(14 - 1 downto 0);
    tx_din_good_V_load_load_fu_397_p1 <= tx_din_good_V_fu_170;
    tx_stat_avail_phi_fu_309_p4 <= tx_stat_avail_reg_305;

    -- tx_status_V_read assign process. --
    tx_status_V_read_assign_proc : process(tx_status_V_empty_n, ap_sig_cseq_ST_st2_fsm_1)
    begin
        if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and (ap_const_logic_1 = tx_status_V_empty_n))) then 
            tx_status_V_read <= ap_const_logic_1;
        else 
            tx_status_V_read <= ap_const_logic_0;
        end if; 
    end process;

    tx_status_V_read_nbread_fu_293_p2_0 <= (0=>tx_status_V_empty_n, others=>'-');
end behav;
