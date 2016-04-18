library ieee;
use ieee.std_logic_1164.all;

entity mac is
    generic (
        --! @brief Determines whether AXI Lite or Configuration vector is used for configuration
        axi_lite_config_g   : integer range 0 to 1  := 1);
    port (
        ------------------------------------------------------------------------
        -- AXI TX user stream
        ------------------------------------------------------------------------
        --! @brief TX clock
        s_axis_aclk       : in  std_logic;
        --! @brief TX synchronous reset
        s_axis_aresetn    : in  std_logic;
        --! @brief TX AXI stream valid
        s_axis_tvalid     : in  std_logic;
        --! @brief TX AXI stream ready
        s_axis_tready     : out std_logic;
        --! @brief TX AXI stream data
        s_axis_tdata      : in  std_logic_vector(7 downto 0);
        --! @brief TX AXI stream last
        s_axis_tlast      : in  std_logic;
        --! @brief TX AXI stream user
        s_axis_tuser      : in  std_logic;
        ------------------------------------------------------------------------
        -- GMII TX stream
        ------------------------------------------------------------------------
        --! @brief GMII tx data
        gmii_txd          : out std_logic_vector(7 downto 0);
        --! @brief GMII tx enable
        gmii_tx_en        : out std_logic;
        --! @brief GMII tx error
        gmii_tx_er        : out std_logic;
        ------------------------------------------------------------------------
        -- AXI RX user stream
        ------------------------------------------------------------------------
        --! @brief RX clock
        m_axis_aclk       : in  std_logic;
        --! @brief RX synchronous reset
        m_axis_aresetn    : in  std_logic;
        --! @brief RX AXI stream data
        m_axis_tdata      : out std_logic_vector(7 downto 0);
        --! @brief RX AXI stream valid
        m_axis_tvalid     : out std_logic;
        --! @brief RX AXI stream last
        m_axis_tlast      : out std_logic;
        --! @brief RX AXI stream last
        m_axis_tdest      : out std_logic_vector(7 downto 0);
        --! @brief RX AXI stream user
        m_axis_tuser      : out std_logic;
        ------------------------------------------------------------------------
        -- GMII RX signals
        ------------------------------------------------------------------------
        --! @brief GMII rx data
        gmii_rxd          : in  std_logic_vector (7 downto 0);
        --! @brief GMII rx data valid
        gmii_dv           : in  std_logic;
        --! @brief GMII rx error signal
        gmii_er           : in  std_logic;

        ------------------------------------------------------------------------
        -- AXI lite interface
        ------------------------------------------------------------------------
        --! @brief Clock for AXI4-Lite
        s_axi_lite_aclk    : in  std_logic;
        --! @brief AXI Lite synchronous reset active at zero
        s_axi_lite_aresetn : in  std_logic;
        --! @brief AXI Lite write address
        s_axi_lite_awaddr  : in  std_logic_vector(10 downto 0);
        --! @brief AXI Lite write address valid
        s_axi_lite_awvalid : in  std_logic;
        --! @brief AXI Lite write address ready
        s_axi_lite_awready : out std_logic;
        --! @brief AXI Lite write data
        s_axi_lite_wdata   : in  std_logic_vector(31 downto 0);
        --! @brief AXI Lite write strobe
        s_axi_lite_wstrb   : in  std_logic_vector(3 downto 0);
        --! @brief AXI Lite write valid
        s_axi_lite_wvalid  : in  std_logic;
        --! @brief AXI Lite write ready
        s_axi_lite_wready  : out std_logic;
        --! @brief AXI Lite write response
        s_axi_lite_bresp   : out std_logic_vector(1 downto 0);
        --! @brief AXI Lite write response valid
        s_axi_lite_bvalid  : out std_logic;
        --! @brief AXI Lite write response ready
        s_axi_lite_bready  : in  std_logic;
        --! @brief AXI Lite read address
        s_axi_lite_araddr  : in  std_logic_vector(10 downto 0);
        --! @brief AXI Lite read address valid
        s_axi_lite_arvalid : in  std_logic;
        --! @brief AXI Lite read address ready
        s_axi_lite_arready : out std_logic;
        --! @brief AXI Lite read data
        s_axi_lite_rdata   : out std_logic_vector(31 downto 0);
        --! @brief AXI Lite read response
        s_axi_lite_rresp   : out std_logic_vector(1 downto 0);
        --! @brief AXI Lite read data/response valid
        s_axi_lite_rvalid  : out std_logic;
        --! @brief AXI Lite read data/response ready
        s_axi_lite_rready  : in  std_logic

        );
end mac;

architecture rtl of mac is
    signal m_gmii_V_din     : STD_LOGIC_VECTOR (9 downto 0);
    signal tx_status        : STD_LOGIC_VECTOR (19 downto 0);
    signal tx_status_vld    : STD_LOGIC;
begin
    transmit_i: entity work.transmit
        port map (
            ap_clk           => s_axis_aclk,
            ap_rst_n         => s_axis_aresetn,
            s_axis_TDATA     => s_axis_tdata,
            s_axis_TVALID    => s_axis_tvalid,
            s_axis_TREADY    => s_axis_tready,
            s_axis_TUSER(0)  => s_axis_tuser,
            s_axis_TLAST(0)  => s_axis_tlast,
            m_gmii_V_din     => m_gmii_V_din,
            m_gmii_V_full_n  => '1',
            m_gmii_V_write   => open,
            tx_status_V_din  => tx_status,
            tx_status_V_full_n => '1',
            tx_status_V_write => tx_status_vld);

    gmii_txd <= m_gmii_V_din(7 downto 0);
    gmii_tx_en <= m_gmii_V_din(8);
    gmii_tx_er <= m_gmii_V_din(9);

    receive_i: entity work.receive
        port map (
            ap_clk           => m_axis_aclk,
            ap_rst_n         => m_axis_aresetn,
            s_gmii_V_dout    => gmii_er & gmii_dv & gmii_rxd,
            s_gmii_V_empty_n => '1',
            s_gmii_V_read    => open,
            m_axis_TDATA     => m_axis_tdata,
            m_axis_TVALID    => m_axis_tvalid,
            m_axis_TREADY    => '1',
            m_axis_TUSER(0)     => m_axis_tuser,
            m_axis_TLAST(0)     => m_axis_tlast,
            rx_status        => open,
            rx_status_ap_vld => open);

    axi_lite_gen : if axi_lite_config_g = 1 generate
        --! @brief Control and statistic registers accessed over axi lite interface.
        axi_lite_interface_i : entity work.axi_lite
            port map (
                ap_clk     => s_axi_lite_aclk,
                ap_rst_n    => s_axi_lite_aresetn,
                s_axi_axi_lite_bus_awaddr  => s_axi_lite_awaddr,
                s_axi_axi_lite_bus_awvalid => s_axi_lite_awvalid,
                s_axi_axi_lite_bus_awready => s_axi_lite_awready,
                s_axi_axi_lite_bus_wdata   => s_axi_lite_wdata,
                s_axi_axi_lite_bus_wstrb   => s_axi_lite_wstrb,
                s_axi_axi_lite_bus_wvalid  => s_axi_lite_wvalid,
                s_axi_axi_lite_bus_wready  => s_axi_lite_wready,
                s_axi_axi_lite_bus_bresp   => s_axi_lite_bresp,
                s_axi_axi_lite_bus_bvalid  => s_axi_lite_bvalid,
                s_axi_axi_lite_bus_bready  => s_axi_lite_bready,
                s_axi_axi_lite_bus_araddr  => s_axi_lite_araddr,
                s_axi_axi_lite_bus_arvalid => s_axi_lite_arvalid,
                s_axi_axi_lite_bus_arready => s_axi_lite_arready,
                s_axi_axi_lite_bus_rdata   => s_axi_lite_rdata,
                s_axi_axi_lite_bus_rresp   => s_axi_lite_rresp,
                s_axi_axi_lite_bus_rvalid  => s_axi_lite_rvalid,
                s_axi_axi_lite_bus_rready  => s_axi_lite_rready,
                tx_status_V_dout       => tx_status,
                tx_status_V_empty_n    => tx_status_vld,
                tx_status_V_read       => open

                );
    end generate axi_lite_gen;    
    
end architecture rtl;
