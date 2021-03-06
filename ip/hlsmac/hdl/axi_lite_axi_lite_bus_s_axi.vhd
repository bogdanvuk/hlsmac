-- ==============================================================
-- File generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2015.4
-- Copyright (C) 2015 Xilinx Inc. All rights reserved.
-- 
-- ==============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity axi_lite_axi_lite_bus_s_axi is
generic (
    C_S_AXI_ADDR_WIDTH    : INTEGER := 11;
    C_S_AXI_DATA_WIDTH    : INTEGER := 32);
port (
    -- axi4 lite slave signals
    ACLK                  :in   STD_LOGIC;
    ARESET                :in   STD_LOGIC;
    ACLK_EN               :in   STD_LOGIC;
    AWADDR                :in   STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    AWVALID               :in   STD_LOGIC;
    AWREADY               :out  STD_LOGIC;
    WDATA                 :in   STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    WSTRB                 :in   STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH/8-1 downto 0);
    WVALID                :in   STD_LOGIC;
    WREADY                :out  STD_LOGIC;
    BRESP                 :out  STD_LOGIC_VECTOR(1 downto 0);
    BVALID                :out  STD_LOGIC;
    BREADY                :in   STD_LOGIC;
    ARADDR                :in   STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    ARVALID               :in   STD_LOGIC;
    ARREADY               :out  STD_LOGIC;
    RDATA                 :out  STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    RRESP                 :out  STD_LOGIC_VECTOR(1 downto 0);
    RVALID                :out  STD_LOGIC;
    RREADY                :in   STD_LOGIC;
    -- user signals
    rx_bytes_V            :in   STD_LOGIC_VECTOR(31 downto 0);
    rx_64_V               :in   STD_LOGIC_VECTOR(31 downto 0);
    rx_65_127_V           :in   STD_LOGIC_VECTOR(31 downto 0);
    rx_128_255_V          :in   STD_LOGIC_VECTOR(31 downto 0);
    rx_256_511_V          :in   STD_LOGIC_VECTOR(31 downto 0);
    rx_512_1023_V         :in   STD_LOGIC_VECTOR(31 downto 0);
    rx_1024_max_V         :in   STD_LOGIC_VECTOR(31 downto 0);
    tx_64_V               :in   STD_LOGIC_VECTOR(31 downto 0);
    tx_65_127_V           :in   STD_LOGIC_VECTOR(31 downto 0);
    tx_128_255_V          :in   STD_LOGIC_VECTOR(31 downto 0);
    tx_256_511_V          :in   STD_LOGIC_VECTOR(31 downto 0);
    tx_512_1023_V         :in   STD_LOGIC_VECTOR(31 downto 0);
    tx_1024_max_V         :in   STD_LOGIC_VECTOR(31 downto 0);
    rx_good_V             :in   STD_LOGIC_VECTOR(31 downto 0);
    dummy_last_V_i        :out  STD_LOGIC_VECTOR(31 downto 0);
    dummy_last_V_o        :in   STD_LOGIC_VECTOR(31 downto 0);
    dummy_last_V_o_ap_vld :in   STD_LOGIC
);
end entity axi_lite_axi_lite_bus_s_axi;

-- ------------------------Address Info-------------------
-- 0x000 : reserved
-- 0x004 : reserved
-- 0x008 : reserved
-- 0x00c : reserved
-- 0x200 : Data signal of rx_bytes_V
--         bit 31~0 - rx_bytes_V[31:0] (Read)
-- 0x204 : reserved
-- 0x220 : Data signal of rx_64_V
--         bit 31~0 - rx_64_V[31:0] (Read)
-- 0x224 : reserved
-- 0x228 : Data signal of rx_65_127_V
--         bit 31~0 - rx_65_127_V[31:0] (Read)
-- 0x22c : reserved
-- 0x230 : Data signal of rx_128_255_V
--         bit 31~0 - rx_128_255_V[31:0] (Read)
-- 0x234 : reserved
-- 0x238 : Data signal of rx_256_511_V
--         bit 31~0 - rx_256_511_V[31:0] (Read)
-- 0x23c : reserved
-- 0x240 : Data signal of rx_512_1023_V
--         bit 31~0 - rx_512_1023_V[31:0] (Read)
-- 0x244 : reserved
-- 0x248 : Data signal of rx_1024_max_V
--         bit 31~0 - rx_1024_max_V[31:0] (Read)
-- 0x24c : reserved
-- 0x258 : Data signal of tx_64_V
--         bit 31~0 - tx_64_V[31:0] (Read)
-- 0x25c : reserved
-- 0x260 : Data signal of tx_65_127_V
--         bit 31~0 - tx_65_127_V[31:0] (Read)
-- 0x264 : reserved
-- 0x268 : Data signal of tx_128_255_V
--         bit 31~0 - tx_128_255_V[31:0] (Read)
-- 0x26c : reserved
-- 0x270 : Data signal of tx_256_511_V
--         bit 31~0 - tx_256_511_V[31:0] (Read)
-- 0x274 : reserved
-- 0x278 : Data signal of tx_512_1023_V
--         bit 31~0 - tx_512_1023_V[31:0] (Read)
-- 0x27c : reserved
-- 0x280 : Data signal of tx_1024_max_V
--         bit 31~0 - tx_1024_max_V[31:0] (Read)
-- 0x284 : reserved
-- 0x290 : Data signal of rx_good_V
--         bit 31~0 - rx_good_V[31:0] (Read)
-- 0x294 : reserved
-- 0x4f0 : Data signal of dummy_last_V_i
--         bit 31~0 - dummy_last_V_i[31:0] (Read/Write)
-- 0x4f4 : reserved
-- 0x4f8 : Data signal of dummy_last_V_o
--         bit 31~0 - dummy_last_V_o[31:0] (Read)
-- 0x4fc : Control signal of dummy_last_V_o
--         bit 0  - dummy_last_V_o_ap_vld (Read/COR)
--         others - reserved
-- (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

architecture behave of axi_lite_axi_lite_bus_s_axi is
    type states is (wridle, wrdata, wrresp, rdidle, rddata);  -- read and write fsm states
    signal wstate, wnext, rstate, rnext: states;
    constant ADDR_RX_BYTES_V_DATA_0     : INTEGER := 16#200#;
    constant ADDR_RX_BYTES_V_CTRL       : INTEGER := 16#204#;
    constant ADDR_RX_64_V_DATA_0        : INTEGER := 16#220#;
    constant ADDR_RX_64_V_CTRL          : INTEGER := 16#224#;
    constant ADDR_RX_65_127_V_DATA_0    : INTEGER := 16#228#;
    constant ADDR_RX_65_127_V_CTRL      : INTEGER := 16#22c#;
    constant ADDR_RX_128_255_V_DATA_0   : INTEGER := 16#230#;
    constant ADDR_RX_128_255_V_CTRL     : INTEGER := 16#234#;
    constant ADDR_RX_256_511_V_DATA_0   : INTEGER := 16#238#;
    constant ADDR_RX_256_511_V_CTRL     : INTEGER := 16#23c#;
    constant ADDR_RX_512_1023_V_DATA_0  : INTEGER := 16#240#;
    constant ADDR_RX_512_1023_V_CTRL    : INTEGER := 16#244#;
    constant ADDR_RX_1024_MAX_V_DATA_0  : INTEGER := 16#248#;
    constant ADDR_RX_1024_MAX_V_CTRL    : INTEGER := 16#24c#;
    constant ADDR_TX_64_V_DATA_0        : INTEGER := 16#258#;
    constant ADDR_TX_64_V_CTRL          : INTEGER := 16#25c#;
    constant ADDR_TX_65_127_V_DATA_0    : INTEGER := 16#260#;
    constant ADDR_TX_65_127_V_CTRL      : INTEGER := 16#264#;
    constant ADDR_TX_128_255_V_DATA_0   : INTEGER := 16#268#;
    constant ADDR_TX_128_255_V_CTRL     : INTEGER := 16#26c#;
    constant ADDR_TX_256_511_V_DATA_0   : INTEGER := 16#270#;
    constant ADDR_TX_256_511_V_CTRL     : INTEGER := 16#274#;
    constant ADDR_TX_512_1023_V_DATA_0  : INTEGER := 16#278#;
    constant ADDR_TX_512_1023_V_CTRL    : INTEGER := 16#27c#;
    constant ADDR_TX_1024_MAX_V_DATA_0  : INTEGER := 16#280#;
    constant ADDR_TX_1024_MAX_V_CTRL    : INTEGER := 16#284#;
    constant ADDR_RX_GOOD_V_DATA_0      : INTEGER := 16#290#;
    constant ADDR_RX_GOOD_V_CTRL        : INTEGER := 16#294#;
    constant ADDR_DUMMY_LAST_V_I_DATA_0 : INTEGER := 16#4f0#;
    constant ADDR_DUMMY_LAST_V_I_CTRL   : INTEGER := 16#4f4#;
    constant ADDR_DUMMY_LAST_V_O_DATA_0 : INTEGER := 16#4f8#;
    constant ADDR_DUMMY_LAST_V_O_CTRL   : INTEGER := 16#4fc#;
    constant ADDR_BITS         : INTEGER := 11;

    signal waddr               : UNSIGNED(ADDR_BITS-1 downto 0);
    signal wmask               : UNSIGNED(31 downto 0);
    signal aw_hs               : STD_LOGIC;
    signal w_hs                : STD_LOGIC;
    signal rdata_data          : UNSIGNED(31 downto 0);
    signal ar_hs               : STD_LOGIC;
    signal raddr               : UNSIGNED(ADDR_BITS-1 downto 0);
    signal AWREADY_t           : STD_LOGIC;
    signal WREADY_t            : STD_LOGIC;
    signal ARREADY_t           : STD_LOGIC;
    signal RVALID_t            : STD_LOGIC;
    -- internal registers
    signal int_rx_bytes_V      : UNSIGNED(31 downto 0);
    signal int_rx_64_V         : UNSIGNED(31 downto 0);
    signal int_rx_65_127_V     : UNSIGNED(31 downto 0);
    signal int_rx_128_255_V    : UNSIGNED(31 downto 0);
    signal int_rx_256_511_V    : UNSIGNED(31 downto 0);
    signal int_rx_512_1023_V   : UNSIGNED(31 downto 0);
    signal int_rx_1024_max_V   : UNSIGNED(31 downto 0);
    signal int_tx_64_V         : UNSIGNED(31 downto 0);
    signal int_tx_65_127_V     : UNSIGNED(31 downto 0);
    signal int_tx_128_255_V    : UNSIGNED(31 downto 0);
    signal int_tx_256_511_V    : UNSIGNED(31 downto 0);
    signal int_tx_512_1023_V   : UNSIGNED(31 downto 0);
    signal int_tx_1024_max_V   : UNSIGNED(31 downto 0);
    signal int_rx_good_V       : UNSIGNED(31 downto 0);
    signal int_dummy_last_V_i  : UNSIGNED(31 downto 0);
    signal int_dummy_last_V_o  : UNSIGNED(31 downto 0);
    signal int_dummy_last_V_o_ap_vld : STD_LOGIC;


begin
-- ----------------------- Instantiation------------------

-- ----------------------- AXI WRITE ---------------------
    AWREADY_t <=  '1' when wstate = wridle else '0';
    AWREADY   <=  AWREADY_t;
    WREADY_t  <=  '1' when wstate = wrdata else '0';
    WREADY    <=  WREADY_t;
    BRESP     <=  "00";  -- OKAY
    BVALID    <=  '1' when wstate = wrresp else '0';
    wmask     <=  (31 downto 24 => WSTRB(3), 23 downto 16 => WSTRB(2), 15 downto 8 => WSTRB(1), 7 downto 0 => WSTRB(0));
    aw_hs     <=  AWVALID and AWREADY_t;
    w_hs      <=  WVALID and WREADY_t;

    -- write FSM
    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                wstate <= wridle;
            elsif (ACLK_EN = '1') then
                wstate <= wnext;
            end if;
        end if;
    end process;

    process (wstate, AWVALID, WVALID, BREADY)
    begin
        case (wstate) is
        when wridle =>
            if (AWVALID = '1') then
                wnext <= wrdata;
            else
                wnext <= wridle;
            end if;
        when wrdata =>
            if (WVALID = '1') then
                wnext <= wrresp;
            else
                wnext <= wrdata;
            end if;
        when wrresp =>
            if (BREADY = '1') then
                wnext <= wridle;
            else
                wnext <= wrresp;
            end if;
        when others =>
            wnext <= wridle;
        end case;
    end process;

    waddr_proc : process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') and ACLK_EN = '1' then
            if (aw_hs = '1') then
                waddr <= UNSIGNED(AWADDR(ADDR_BITS-1 downto 0));
            end if;
        end if;
    end process;

-- ----------------------- AXI READ ----------------------
    ARREADY_t <= '1' when (rstate = rdidle) else '0';
    ARREADY <= ARREADY_t;
    RDATA   <= STD_LOGIC_VECTOR(rdata_data);
    RRESP   <= "00";  -- OKAY
    RVALID_t  <= '1' when (rstate = rddata) else '0';
    RVALID    <= RVALID_t;
    ar_hs   <= ARVALID and ARREADY_t;
    raddr   <= UNSIGNED(ARADDR(ADDR_BITS-1 downto 0));

    -- read FSM
    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                rstate <= rdidle;
            elsif (ACLK_EN = '1') then
                rstate <= rnext;
            end if;
        end if;
    end process;

    process (rstate, ARVALID, RREADY, RVALID_t)
    begin
        case (rstate) is
        when rdidle =>
            if (ARVALID = '1') then
                rnext <= rddata;
            else
                rnext <= rdidle;
            end if;
        when rddata =>
            if (RREADY = '1' and RVALID_t = '1') then
                rnext <= rdidle;
            else
                rnext <= rddata;
            end if;
        when others =>
            rnext <= rdidle;
        end case;
    end process;

    rdata_proc : process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') and ACLK_EN = '1' then
            if (ar_hs = '1') then
                case (TO_INTEGER(raddr)) is
                when ADDR_RX_BYTES_V_DATA_0 =>
                    rdata_data <= RESIZE(int_rx_bytes_V(31 downto 0), 32);
                when ADDR_RX_64_V_DATA_0 =>
                    rdata_data <= RESIZE(int_rx_64_V(31 downto 0), 32);
                when ADDR_RX_65_127_V_DATA_0 =>
                    rdata_data <= RESIZE(int_rx_65_127_V(31 downto 0), 32);
                when ADDR_RX_128_255_V_DATA_0 =>
                    rdata_data <= RESIZE(int_rx_128_255_V(31 downto 0), 32);
                when ADDR_RX_256_511_V_DATA_0 =>
                    rdata_data <= RESIZE(int_rx_256_511_V(31 downto 0), 32);
                when ADDR_RX_512_1023_V_DATA_0 =>
                    rdata_data <= RESIZE(int_rx_512_1023_V(31 downto 0), 32);
                when ADDR_RX_1024_MAX_V_DATA_0 =>
                    rdata_data <= RESIZE(int_rx_1024_max_V(31 downto 0), 32);
                when ADDR_TX_64_V_DATA_0 =>
                    rdata_data <= RESIZE(int_tx_64_V(31 downto 0), 32);
                when ADDR_TX_65_127_V_DATA_0 =>
                    rdata_data <= RESIZE(int_tx_65_127_V(31 downto 0), 32);
                when ADDR_TX_128_255_V_DATA_0 =>
                    rdata_data <= RESIZE(int_tx_128_255_V(31 downto 0), 32);
                when ADDR_TX_256_511_V_DATA_0 =>
                    rdata_data <= RESIZE(int_tx_256_511_V(31 downto 0), 32);
                when ADDR_TX_512_1023_V_DATA_0 =>
                    rdata_data <= RESIZE(int_tx_512_1023_V(31 downto 0), 32);
                when ADDR_TX_1024_MAX_V_DATA_0 =>
                    rdata_data <= RESIZE(int_tx_1024_max_V(31 downto 0), 32);
                when ADDR_RX_GOOD_V_DATA_0 =>
                    rdata_data <= RESIZE(int_rx_good_V(31 downto 0), 32);
                when ADDR_DUMMY_LAST_V_I_DATA_0 =>
                    rdata_data <= RESIZE(int_dummy_last_V_i(31 downto 0), 32);
                when ADDR_DUMMY_LAST_V_O_DATA_0 =>
                    rdata_data <= RESIZE(int_dummy_last_V_o(31 downto 0), 32);
                when ADDR_DUMMY_LAST_V_O_CTRL =>
                    rdata_data <= (0 => int_dummy_last_V_o_ap_vld, others => '0');
                when others =>
                    rdata_data <= (others => '0');
                end case;
            end if;
        end if;
    end process;

-- ----------------------- Register logic ----------------
    dummy_last_V_i       <= STD_LOGIC_VECTOR(int_dummy_last_V_i);

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_rx_bytes_V <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_rx_bytes_V <= UNSIGNED(rx_bytes_V); -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_rx_64_V <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_rx_64_V <= UNSIGNED(rx_64_V); -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_rx_65_127_V <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_rx_65_127_V <= UNSIGNED(rx_65_127_V); -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_rx_128_255_V <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_rx_128_255_V <= UNSIGNED(rx_128_255_V); -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_rx_256_511_V <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_rx_256_511_V <= UNSIGNED(rx_256_511_V); -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_rx_512_1023_V <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_rx_512_1023_V <= UNSIGNED(rx_512_1023_V); -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_rx_1024_max_V <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_rx_1024_max_V <= UNSIGNED(rx_1024_max_V); -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_tx_64_V <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_tx_64_V <= UNSIGNED(tx_64_V); -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_tx_65_127_V <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_tx_65_127_V <= UNSIGNED(tx_65_127_V); -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_tx_128_255_V <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_tx_128_255_V <= UNSIGNED(tx_128_255_V); -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_tx_256_511_V <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_tx_256_511_V <= UNSIGNED(tx_256_511_V); -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_tx_512_1023_V <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_tx_512_1023_V <= UNSIGNED(tx_512_1023_V); -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_tx_1024_max_V <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_tx_1024_max_V <= UNSIGNED(tx_1024_max_V); -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_rx_good_V <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_rx_good_V <= UNSIGNED(rx_good_V); -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_DUMMY_LAST_V_I_DATA_0) then
                    int_dummy_last_V_i(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_dummy_last_V_i(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_dummy_last_V_o <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (dummy_last_V_o_ap_vld = '1') then
                    int_dummy_last_V_o <= UNSIGNED(dummy_last_V_o); -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_dummy_last_V_o_ap_vld <= '0';
            elsif (ACLK_EN = '1') then
                if (dummy_last_V_o_ap_vld = '1') then
                    int_dummy_last_V_o_ap_vld <= '1';
                elsif (ar_hs = '1' and raddr = ADDR_DUMMY_LAST_V_O_CTRL) then
                    int_dummy_last_V_o_ap_vld <= '0'; -- clear on read
                end if;
            end if;
        end if;
    end process;


-- ----------------------- Memory logic ------------------

end architecture behave;
