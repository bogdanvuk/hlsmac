library ieee;
use ieee.std_logic_1164.all;

entity mac is
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
        gmii_er           : in  std_logic
        );
end mac;

architecture rtl of mac is
    signal m_gmii_V_din     : STD_LOGIC_VECTOR (9 downto 0);
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
            m_gmii_V_full_n  => '0',
            m_gmii_V_write   => open,
            tx_status        => open,
            tx_status_ap_vld => open);

    gmii_txd <= m_gmii_V_din(7 downto 0);
    gmii_tx_en <= m_gmii_V_din(8);
    gmii_tx_er <= m_gmii_V_din(9);

    receive_i: entity work.receive
        port map (
            ap_clk           => m_axis_aclk,
            ap_rst_n         => m_axis_aresetn,
            s_gmii_V_dout    => gmii_er & gmii_dv & gmii_rxd,
            s_gmii_V_empty_n => '0',
            s_gmii_V_read    => open,
            m_axis_TDATA     => m_axis_tdata,
            m_axis_TVALID    => m_axis_tvalid,
            m_axis_TREADY    => '1',
            m_axis_TUSER(0)     => m_axis_tuser,
            m_axis_TLAST(0)     => m_axis_tlast,
            rx_status        => open,
            rx_status_ap_vld => open);
    
    
end architecture rtl;
