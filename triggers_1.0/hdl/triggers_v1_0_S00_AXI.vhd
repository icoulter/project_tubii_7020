library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity triggers_v1_0_S00_AXI is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 5
	);
	port (
		-- Users to add ports here
		EXT_TRIG_IN    : in std_logic_vector(15 downto 0);
        MTCA_MIMIC_IN  : in std_logic_vector(1 downto 0);
        INT_TRIG_IN    : in std_logic_vector(3 downto 0);
        TELLIE_TRIG_IN : in std_logic;
        SMELLIE_TRIG_IN : in std_logic;
        GTRIG          : in std_logic;
        SYNCi          : in std_logic;
        SYNC24i        : in std_logic;
        GTID_in        : in std_logic_vector(23 downto 0);
        SYNCo          : out std_logic;
        SYNC24o        : out std_logic;
        RESETGTID      : out std_logic;
        GTRIGout       : out std_logic;   
        TRIG_WORD      : out std_logic_vector(23 downto 0);
        DTRIG_WORD     : in std_logic_vector(23 downto 0);
        TUBII_WORD     : out std_logic_vector(47 downto 0);
        TRIG_OUT       : out std_logic;
        SPEAKER        : out std_logic;
        COUNTER        : out std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Global Clock Signal
		S_AXI_ACLK	: in std_logic;
		-- Global Reset Signal. This Signal is Active LOW
		S_AXI_ARESETN	: in std_logic;
		-- Write address (issued by master, acceped by Slave)
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Write channel Protection type. This signal indicates the
    -- privilege and security level of the transaction, and whether
    -- the transaction is a data access or an instruction access.
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		-- Write address valid. This signal indicates that the master signaling
    -- valid write address and control information.
		S_AXI_AWVALID	: in std_logic;
		-- Write address ready. This signal indicates that the slave is ready
    -- to accept an address and associated control signals.
		S_AXI_AWREADY	: out std_logic;
		-- Write data (issued by master, acceped by Slave) 
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. This signal indicates which byte lanes hold
    -- valid data. There is one write strobe bit for each eight
    -- bits of the write data bus.    
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		-- Write valid. This signal indicates that valid write
    -- data and strobes are available.
		S_AXI_WVALID	: in std_logic;
		-- Write ready. This signal indicates that the slave
    -- can accept the write data.
		S_AXI_WREADY	: out std_logic;
		-- Write response. This signal indicates the status
    -- of the write transaction.
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		-- Write response valid. This signal indicates that the channel
    -- is signaling a valid write response.
		S_AXI_BVALID	: out std_logic;
		-- Response ready. This signal indicates that the master
    -- can accept a write response.
		S_AXI_BREADY	: in std_logic;
		-- Read address (issued by master, acceped by Slave)
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Protection type. This signal indicates the privilege
    -- and security level of the transaction, and whether the
    -- transaction is a data access or an instruction access.
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		-- Read address valid. This signal indicates that the channel
    -- is signaling valid read address and control information.
		S_AXI_ARVALID	: in std_logic;
		-- Read address ready. This signal indicates that the slave is
    -- ready to accept an address and associated control signals.
		S_AXI_ARREADY	: out std_logic;
		-- Read data (issued by slave)
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the
    -- read transfer.
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		-- Read valid. This signal indicates that the channel is
    -- signaling the required read data.
		S_AXI_RVALID	: out std_logic;
		-- Read ready. This signal indicates that the master can
    -- accept the read data and response information.
		S_AXI_RREADY	: in std_logic
	);
end triggers_v1_0_S00_AXI;

architecture arch_imp of triggers_v1_0_S00_AXI is

	-- AXI4LITE signals
	signal axi_awaddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_awready	: std_logic;
	signal axi_wready	: std_logic;
	signal axi_bresp	: std_logic_vector(1 downto 0);
	signal axi_bvalid	: std_logic;
	signal axi_araddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_arready	: std_logic;
	signal axi_rdata	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal axi_rresp	: std_logic_vector(1 downto 0);
	signal axi_rvalid	: std_logic;

	-- Example-specific design signals
	-- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	-- ADDR_LSB is used for addressing 32/64 bit registers/memories
	-- ADDR_LSB = 2 for 32 bits (n downto 2)
	-- ADDR_LSB = 3 for 64 bits (n downto 3)
	constant ADDR_LSB  : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
	constant OPT_MEM_ADDR_BITS : integer := 2;
	------------------------------------------------
	---- Signals for user logic register space example
	--------------------------------------------------
	---- Number of Slave Registers 8
	signal slv_reg0	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg2	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg3	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg4	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg5	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg6	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg7	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg_rden	: std_logic;
	signal slv_reg_wren	: std_logic;
	signal reg_data_out	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal byte_index	: integer;
	signal slv_regGT	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	--signal counter	:std_logic_vector(4 downto 0);
    signal gt_flag  : std_logic;
	signal unread	: std_logic;
    signal synced   : std_logic;
    signal treset    : std_logic;
    signal tsync    : std_logic;
    signal tsync24  : std_logic;

begin
	-- I/O Connections assignments

	S_AXI_AWREADY	<= axi_awready;
	S_AXI_WREADY	<= axi_wready;
	S_AXI_BRESP	<= axi_bresp;
	S_AXI_BVALID	<= axi_bvalid;
	S_AXI_ARREADY	<= axi_arready;
	S_AXI_RDATA	<= axi_rdata;
	S_AXI_RRESP	<= axi_rresp;
	S_AXI_RVALID	<= axi_rvalid;
	-- Implement axi_awready generation
	-- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	-- de-asserted when reset is low.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awready <= '0';
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
	        -- slave is ready to accept write address when
	        -- there is a valid write address and write data
	        -- on the write address and data bus. This design 
	        -- expects no outstanding transactions. 
	        axi_awready <= '1';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	-- Implement axi_awaddr latching
	-- This process is used to latch the address when both 
	-- S_AXI_AWVALID and S_AXI_WVALID are valid. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awaddr <= (others => '0');
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
	        -- Write Address latching
	        axi_awaddr <= S_AXI_AWADDR;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_wready generation
	-- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1') then
	          -- slave is ready to accept write data when 
	          -- there is a valid write address and write data
	          -- on the write address and data bus. This design 
	          -- expects no outstanding transactions.           
	          axi_wready <= '1';
	      else
	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;
	end process; 

	-- Implement memory mapped register select and write logic generation
	-- The write data is accepted and written to memory mapped registers when
	-- axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	-- select byte enables of slave registers while writing.
	-- These registers are cleared when reset (active low) is applied.
	-- Slave register write enable is asserted when valid address and data are available
	-- and the slave is ready to accept the write address and write data.
	slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;

	process (S_AXI_ACLK)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
	begin
	  if rising_edge(S_AXI_ACLK) then 
  	    -- slv_reg0 is trigger in (for debugging)
        -- slv_reg1 is counter mask
        -- slv_reg2 is speaker mask
        -- slv_reg3 is trigger mask
        slv_reg0(15 downto 0)  <= EXT_TRIG_IN(15 downto 0);
        slv_reg0(17 downto 16) <= MTCA_MIMIC_IN(1 downto 0);
        slv_reg0(21 downto 18) <= INT_TRIG_IN(3 downto 0);
        slv_reg0(22) <= TELLIE_TRIG_IN;
        slv_reg0(23) <= SMELLIE_TRIG_IN;
        TRIG_WORD(15 downto 0)  <= EXT_TRIG_IN(15 downto 0);
        TRIG_WORD(17 downto 16) <= MTCA_MIMIC_IN(1 downto 0);
        TRIG_WORD(21 downto 18) <= INT_TRIG_IN(3 downto 0);
        TRIG_WORD(22) <= TELLIE_TRIG_IN;
        TRIG_WORD(23) <= SMELLIE_TRIG_IN;
        TUBII_WORD(15 downto 0)  <= EXT_TRIG_IN(15 downto 0);
        TUBII_WORD(17 downto 16) <= MTCA_MIMIC_IN(1 downto 0);
        TUBII_WORD(21 downto 18) <= INT_TRIG_IN(3 downto 0);
        TUBII_WORD(22) <= TELLIE_TRIG_IN;
        TUBII_WORD(23) <= SMELLIE_TRIG_IN;
        --TUBII_WORD(23 downto 0) <= DTRIG_WORD(23 downto 0);
        TUBII_WORD(47 downto 24) <= slv_reg4(23 downto 0);

        --slv_reg4(23 downto 0) <= GTID_in;
        slv_reg5(0) <= SYNCi;
        slv_reg5(1) <= SYNC24i;

        -- Soft GT for initialisation
        if(slv_reg6(0)='1') then
          GTRIGout <= '1';
        else
          GTRIGout <= GTRIG;
        end if;

        -- Reset GTID
        --if(slv_reg7(0) ='1') then -- and treset='0') then
          --treset<='1';
        --  RESETGTID<='1';
        --else
        --  RESETGTID<='0';
        --end if;

        if(slv_reg7(0)='1') then
          slv_reg4 <= "00000000000000000000000000000001";        
	    elsif(SYNC24i='1') then
          slv_reg4 <= "00000000000000000000000000000001";
        elsif(SYNCi='1') then
          slv_reg4(15 downto 0) <= "0000000000000001";
	    elsif GTRIG='1' and unread='0' then
          slv_reg4 <= slv_reg4+1;
          unread<='1';
        elsif GTRIG='0' then
         unread<='0';
        end if;

        --if(SYNCi ='1' and tsync='0') then
          --tsync<='1';
          --SYNCo<='1';
        --end if;

        --if(SYNC24i ='1' and tsync24='0') then
          --tsync24<='1';
          --SYNC24o<='1';
        --end if;

        --if(GTRIG ='1' and unread='0') then
          --treset <= '0';
          --tsync <= '0';
          --tsync24 <= '0';
          --SYNCo<='0';
          --SYNC24o<='0';
          --RESETGTID<='0';
          --unread <= '1';
        --elsif(GTRIG ='0') then
          --unread <= '0';
        --end if;

        ---- TUBII TRIGGER
        if((EXT_TRIG_IN(0)='1' and slv_reg3(0)='1') or (EXT_TRIG_IN(1)='1' and slv_reg3(1)='1') or (EXT_TRIG_IN(2)='1' and slv_reg3(2)='1') or (EXT_TRIG_IN(3)='1' and slv_reg3(3)='1') or (EXT_TRIG_IN(4)='1' and slv_reg3(4)='1') or (EXT_TRIG_IN(5)='1' and slv_reg3(5)='1') or (EXT_TRIG_IN(6)='1' and slv_reg3(6)='1') or (EXT_TRIG_IN(7)='1' and slv_reg3(7)='1') or (EXT_TRIG_IN(8)='1' and slv_reg3(8)='1') or (EXT_TRIG_IN(9)='1' and slv_reg3(9)='1') or (EXT_TRIG_IN(10)='1' and slv_reg3(10)='1') or (EXT_TRIG_IN(11)='1' and slv_reg3(11)='1') or (EXT_TRIG_IN(12)='1' and slv_reg3(12)='1') or (EXT_TRIG_IN(13)='1' and slv_reg3(13)='1') or (EXT_TRIG_IN(14)='1' and slv_reg3(14)='1') or (EXT_TRIG_IN(15)='1' and slv_reg3(15)='1')) then
          TRIG_OUT <= '1';
        elsif((MTCA_MIMIC_IN(0)='1' and slv_reg3(16)='1') or (MTCA_MIMIC_IN(1)='1' and slv_reg3(17)='1')) then
          TRIG_OUT <= '1';
        elsif((INT_TRIG_IN(0)='1' and slv_reg3(18)='1') or (INT_TRIG_IN(1)='1' and slv_reg3(19)='1') or (INT_TRIG_IN(2)='1' and slv_reg3(20)='1') or (INT_TRIG_IN(3)='1' and slv_reg3(21)='1')) then
          TRIG_OUT <= '1';
        elsif((TELLIE_TRIG_IN='1' and slv_reg3(22)='1') or (SMELLIE_TRIG_IN='1' and slv_reg3(23)='1')) then
          TRIG_OUT <= '1';
        else
          TRIG_OUT <= '0';
        end if;

        ---- SPEAKER
        if((EXT_TRIG_IN(0)='1' and slv_reg2(0)='1') or (EXT_TRIG_IN(1)='1' and slv_reg2(1)='1') or (EXT_TRIG_IN(2)='1' and slv_reg2(2)='1') or (EXT_TRIG_IN(3)='1' and slv_reg2(3)='1') or (EXT_TRIG_IN(4)='1' and slv_reg2(4)='1') or (EXT_TRIG_IN(5)='1' and slv_reg2(5)='1') or (EXT_TRIG_IN(6)='1' and slv_reg2(6)='1') or (EXT_TRIG_IN(7)='1' and slv_reg2(7)='1') or (EXT_TRIG_IN(8)='1' and slv_reg2(8)='1') or (EXT_TRIG_IN(9)='1' and slv_reg2(9)='1') or (EXT_TRIG_IN(10)='1' and slv_reg2(10)='1') or (EXT_TRIG_IN(11)='1' and slv_reg2(11)='1') or (EXT_TRIG_IN(12)='1' and slv_reg2(12)='1') or (EXT_TRIG_IN(13)='1' and slv_reg2(13)='1') or (EXT_TRIG_IN(14)='1' and slv_reg2(14)='1') or (EXT_TRIG_IN(15)='1' and slv_reg2(15)='1')) then
          SPEAKER <= '1';
        elsif((MTCA_MIMIC_IN(0)='1' and slv_reg2(16)='1') or (MTCA_MIMIC_IN(1)='1' and slv_reg2(17)='1')) then
          SPEAKER <= '1';
        elsif((INT_TRIG_IN(0)='1' and slv_reg2(18)='1') or (INT_TRIG_IN(1)='1' and slv_reg2(19)='1') or (INT_TRIG_IN(2)='1' and slv_reg2(20)='1') or (INT_TRIG_IN(3)='1' and slv_reg2(21)='1')) then
          SPEAKER <= '1';
        elsif((TELLIE_TRIG_IN='1' and slv_reg2(22)='1') or (SMELLIE_TRIG_IN='1' and slv_reg2(23)='1')) then
          SPEAKER <= '1';
        elsif( GTRIG='1' and slv_reg2(24)='1') then
          SPEAKER <= '1';
        else
          SPEAKER <= '0';
        end if;

        ---- COUNTER
        if((EXT_TRIG_IN(0)='1' and slv_reg1(0)='1') or (EXT_TRIG_IN(1)='1' and slv_reg1(1)='1') or (EXT_TRIG_IN(2)='1' and slv_reg1(2)='1') or (EXT_TRIG_IN(3)='1' and slv_reg1(3)='1') or (EXT_TRIG_IN(4)='1' and slv_reg1(4)='1') or (EXT_TRIG_IN(5)='1' and slv_reg1(5)='1') or (EXT_TRIG_IN(6)='1' and slv_reg1(6)='1') or (EXT_TRIG_IN(7)='1' and slv_reg1(7)='1') or (EXT_TRIG_IN(8)='1' and slv_reg1(8)='1') or (EXT_TRIG_IN(9)='1' and slv_reg1(9)='1') or (EXT_TRIG_IN(10)='1' and slv_reg1(10)='1') or (EXT_TRIG_IN(11)='1' and slv_reg1(11)='1') or (EXT_TRIG_IN(12)='1' and slv_reg1(12)='1') or (EXT_TRIG_IN(13)='1' and slv_reg1(13)='1') or (EXT_TRIG_IN(14)='1' and slv_reg1(14)='1') or (EXT_TRIG_IN(15)='1' and slv_reg1(15)='1')) then
          COUNTER <= '1';
        elsif((MTCA_MIMIC_IN(0)='1' and slv_reg1(16)='1') or (MTCA_MIMIC_IN(1)='1' and slv_reg1(17)='1')) then
          COUNTER <= '1';
        elsif((INT_TRIG_IN(0)='1' and slv_reg1(18)='1') or (INT_TRIG_IN(1)='1' and slv_reg1(19)='1') or (INT_TRIG_IN(2)='1' and slv_reg1(20)='1') or (INT_TRIG_IN(3)='1' and slv_reg1(21)='1')) then
          COUNTER <= '1';
        elsif((TELLIE_TRIG_IN='1' and slv_reg1(22)='1') or (SMELLIE_TRIG_IN='1' and slv_reg1(23)='1')) then
          COUNTER <= '1';
        elsif( GTRIG='1' and slv_reg1(24)='1') then
          COUNTER <= '1';
        else
          COUNTER <= '0';
        end if;

	    if S_AXI_ARESETN = '0' then
	      slv_reg0 <= (others => '0');
	      slv_reg1 <= (others => '0');
	      slv_reg2 <= (others => '0');
	      slv_reg3 <= (others => '0');
	      slv_reg4 <= (others => '0');
	      slv_reg5 <= (others => '0');
	      slv_reg6 <= (others => '0');
	      slv_reg7 <= (others => '0');
	    else
	      loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	      if (slv_reg_wren = '1') then
	        case loc_addr is
	          when b"000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 0
	                slv_reg0(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 1
	                slv_reg1(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 2
	                slv_reg2(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 3
	                slv_reg3(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 4
	                slv_reg4(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 5
	                slv_reg5(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 6
	                slv_reg6(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 7
	                slv_reg7(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when others =>
	            slv_reg0 <= slv_reg0;
	            slv_reg1 <= slv_reg1;
	            slv_reg2 <= slv_reg2;
	            slv_reg3 <= slv_reg3;
	            slv_reg4 <= slv_reg4;
	            slv_reg5 <= slv_reg5;
	            slv_reg6 <= slv_reg6;
	            slv_reg7 <= slv_reg7;
	        end case;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement write response logic generation
	-- The write response and response valid signals are asserted by the slave 
	-- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	-- This marks the acceptance of address and indicates the status of 
	-- write transaction.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp   <= "00"; --need to work more on the responses
	    else
	      if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
	        axi_bvalid <= '1';
	        axi_bresp  <= "00"; 
	      elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
	        axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arready generation
	-- axi_arready is asserted for one S_AXI_ACLK clock cycle when
	-- S_AXI_ARVALID is asserted. axi_awready is 
	-- de-asserted when reset (active low) is asserted. 
	-- The read address is also latched when S_AXI_ARVALID is 
	-- asserted. axi_araddr is reset to zero on reset assertion.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_arready <= '0';
	      axi_araddr  <= (others => '1');
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1') then
	        -- indicates that the slave has acceped the valid read address
	        axi_arready <= '1';
	        -- Read Address latching 
	        axi_araddr  <= S_AXI_ARADDR;           
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arvalid generation
	-- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	-- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	-- data are available on the axi_rdata bus at this instance. The 
	-- assertion of axi_rvalid marks the validity of read data on the 
	-- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	-- is deasserted on reset (active low). axi_rresp and axi_rdata are 
	-- cleared to zero on reset (active low).  
	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
	        -- Valid read data is available at the read data bus
	        axi_rvalid <= '1';
	        axi_rresp  <= "00"; -- 'OKAY' response
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        -- Read data is accepted by the master
	        axi_rvalid <= '0';
	      end if;            
	    end if;
	  end if;
	end process;

	-- Implement memory mapped register select and read logic generation
	-- Slave register read enable is asserted when valid address is available
	-- and the slave is ready to accept the read address.
	slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;

	process (slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7, axi_araddr, S_AXI_ARESETN, slv_reg_rden)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
	begin
	  if S_AXI_ARESETN = '0' then
	    reg_data_out  <= (others => '1');
	  else
	    -- Address decoding for reading registers
	    loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	    case loc_addr is
	      when b"000" =>
	        reg_data_out <= slv_reg0;
	      when b"001" =>
	        reg_data_out <= slv_reg1;
	      when b"010" =>
	        reg_data_out <= slv_reg2;
	      when b"011" =>
	        reg_data_out <= slv_reg3;
	      when b"100" =>
	        reg_data_out <= slv_reg4;
	      when b"101" =>
	        reg_data_out <= slv_reg5;
	      when b"110" =>
	        reg_data_out <= slv_reg6;
	      when b"111" =>
	        reg_data_out <= slv_reg7;
	      when others =>
	        reg_data_out  <= (others => '0');
	    end case;
	  end if;
	end process; 

	-- Output register or memory read data
	process( S_AXI_ACLK ) is
	begin
	  if (rising_edge (S_AXI_ACLK)) then
	    if ( S_AXI_ARESETN = '0' ) then
	      axi_rdata  <= (others => '0');
	    else
	      if (slv_reg_rden = '1') then
	        -- When there is a valid read address (S_AXI_ARVALID) with 
	        -- acceptance of read address by the slave (axi_arready), 
	        -- output the read dada 
	        -- Read address mux
	          axi_rdata <= reg_data_out;     -- register read data
	      end if;   
	    end if;
	  end if;
	end process;


	-- Add user logic here

	-- User logic ends

end arch_imp;