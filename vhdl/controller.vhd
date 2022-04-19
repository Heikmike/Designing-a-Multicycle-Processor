library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        -- instruction opcode
        op         : in  std_logic_vector(5 downto 0);
        opx        : in  std_logic_vector(5 downto 0);
        -- activates branch condition
        branch_op  : out std_logic;
        -- immediate value sign extention
        imm_signed : out std_logic;
        -- instruction register enable
        ir_en      : out std_logic;
        -- PC control signals
        pc_add_imm : out std_logic;
        pc_en      : out std_logic;
        pc_sel_a   : out std_logic;
        pc_sel_imm : out std_logic;
        -- register file enable
        rf_wren    : out std_logic;
        -- multiplexers selections
        sel_addr   : out std_logic;
        sel_b      : out std_logic;
        sel_mem    : out std_logic;
        sel_pc     : out std_logic;
        sel_ra     : out std_logic;
        sel_rC     : out std_logic;
        -- write memory output
        read       : out std_logic;
        write      : out std_logic;
        -- alu op
        op_alu     : out std_logic_vector(5 downto 0)
    );
end controller;

architecture synth of controller is
    type state is (fetch1, fetch2, decode, r_op, store, break, load1, load2, i_op, branch, call, callr, jmp, jmpi, ui_op, ur_op);
    signal current_state, next_state : state;
begin
    branch_op <= '1' when current_state = branch else '0';
    imm_signed <= '1' when current_state = i_op or current_state = load1 or current_state = store else '0';
    ir_en <= '1' when current_state = fetch2 else '0';
    pc_add_imm <= '1' when current_state = branch else '0';
    pc_en <= '1' when current_state = fetch2 or current_state = call or current_state = callr or current_state = jmp or current_state = jmpi else '0';
    pc_sel_a <= '1' when current_state = callr or current_state = jmp else '0';
    pc_sel_imm <= '1' when current_state = call or current_state = jmpi else '0';
    rf_wren <= '1' when current_state = ur_op or current_state = ui_op or current_state = i_op or current_state = r_op or current_state = load2 or current_state = call or current_state = callr else '0';
    sel_addr <= '1' when current_state = load1 or current_state = store else '0';
    sel_b <= '1' when current_state = r_op or current_state = branch else '0';
    sel_mem <= '1' when current_state = load2 else '0';
    sel_pc <= '1' when current_state = call or current_state = callr else '0';
    sel_ra <= '1' when current_state = call or current_state = callr else '0';
    sel_rC <= '1' when current_state = ur_op or current_state = r_op else '0';
    read <= '1' when current_state = fetch1 or current_state = load1 else '0';
    write <= '1' when current_state = store else '0';
    current_state <= fetch1 when reset_n = '0' else next_state;

    state_process : process(clk, reset_n)
    begin
        if reset_n = '0' then next_state <= fetch1;
        end if;

        if rising_edge(clk) and reset_n /= '0' then
            case current_state is
                when fetch1 => next_state <= fetch2;
                when fetch2 => next_state <= decode;
		-- v2Change
                when decode => 
			-- R-Type
			IF op = "111010" THEN
				if opx = "001110" or opx = "011011" or opx = "110001" or opx = "111001" or opx = "001000" or opx = "010000"  or opx = "000110" or opx = "001110" or opx = "010110" or opx = "011110" or opx = "010011" or opx = "011011" or opx = "111011" or opx = "011000" or opx = "100000" or opx = "101000" or opx = "110000" or opx = "000011" or opx = "001011" then next_state <= r_op; 
                elsif opx = "010010" or opx = "011010" or opx = "111010" or opx = "000010" then next_state <= ur_op;
				elsif opx = "011101" then next_state <= callr;
		    	elsif opx = "001101" or opx = "000101" then next_state <= jmp;
				elsif opx = "110100" then next_state <= break;
				end if;
		    	-- I-Type
			ELSE 
				if op = "010101" then next_state <= store;
                elsif op = "010111" then next_state <= load1;
                elsif op = "000100" or op = "001000" or op = "010000" or op = "100000" or op = "011000" or op = "100000" then next_state <= i_op;
		    	elsif op = "000110" or op = "001110" or op = "010110" or op = "011110" or op = "100110" or op = "101110" or op = "110110" then next_state <= branch;
                elsif op = "000000" then next_state <= call;
		    	elsif op = "000001" then next_state <= jmpi;
		    	elsif op = "001100" or op = "010100" or op = "011100" or op = "101000" or op = "110000" then next_state <= ui_op;
		  		end if;
		    	end if; 
		-- v2ChangeEnd
                when r_op => next_state <= fetch1;
                when store => next_state <= fetch1;
                when break => next_state <= break;
                when load1 => next_state <= load2;
                when load2 => next_state <= fetch1;
                when i_op => next_state <= fetch1;
		when branch => next_state <= fetch1;
		when call => next_state <= fetch1;
		when callr => next_state <= fetch1;
		when jmp => next_state <= fetch1;
		when jmpi => next_state <= fetch1;
		when ui_op => next_state<= fetch1;
		when ur_op => next_state <= fetch1;
            end case;
        end if;
    end process;
	-- v2Change
	opalu_process : process(op, opx)
	begin
	-- ROP
	IF op = "111010" THEN
		-- srl (section3-srl, section5.2-srl, section5.2-srli)
		if opx = "011011" or opx = "011011" or opx = "011010" THEN
			op_alu <= "110011";
		-- sll (section5.2-sll, section5.2-slli)
		elsif opx = "010011" or opx = "010010" then 
			op_alu <= "110010";	
		-- sra (section5.2-sra, section5.2-srai)
		elsif opx = "111011" or opx = "111010" then 
			op_alu <= "110111";	
		-- rol (section5.2-rol, section5.2roli)
		elsif opx = "000011" or opx = "000010" then 
			op_alu <= "110000";
		-- ror (section5.2-ror)
		elsif opx = "001011" then 
			op_alu <= "110001";
		-- and (section3-and, section5.2--and) 
		elsif opx = "001110" or opx = "001110" then
			op_alu <= "100001";
		-- (section5.2--or)
		elsif opx = "010110" then
			op_alu <= "100010";
		-- nor (section5.2--nor)
		elsif opx = "000110" then
			op_alu <= "100000";
		-- nor (section5.2--xnor)
		elsif opx = "011110" then
			op_alu <= "100011";
		-- +(5.2 add)
		elsif opx = "110001" then 
			op_alu <= "000000";
		-- +(5.2 sub)
		elsif opx = "111001" then 
			op_alu <= "001000";
		-- signed <= (5.2cmple)
		elsif opx= "001000" then
			op_alu <= "011001";
		-- signed > (5.2cmpgt) 
		elsif opx= "010000" then
			op_alu <= "011010";
		-- not equal(5.2cmpne)
		elsif opx = "011000" then
			op_alu <= "011011";
		-- equal(5.2cmpeq)
		elsif opx = "100000" then
			op_alu <= "011100";
		-- unsigned <= (5.2cmpleu)
		elsif opx = "101000" then
			op_alu <= "011101";
		-- unsigned > (5.2cmpgtu)
		elsif opx = "110000" then
			op_alu <= "011110";
		else 
			op_alu <= "000000";
		END IF;
	-- IOP
	ELSE
		-- and (section5.1-andi) 
		if op = "001100" then
			op_alu <= "100001";
		-- or (section5.1--ori)
		elsif op = "010100" then
			op_alu <= "100010";
		-- nor (section5.1--xori)
		elsif op = "011100" then
			op_alu <= "100011";
		-- +(IOPaddi, IOPldw, IOPstd, section5.1-addi)
		elsif op = "000100" or op = "010111" or op = "010101" or op = "010111" then
			op_alu <= "000000";
		-- signed <= (branch ble 0E, 5.1cmplei)
		elsif op = "001110" or op = "001000" then
			op_alu <= "011001";
		-- signed > (branch bgt 16, 5.1cmpgti, 5.2cmpgt) 
		elsif op = "010110" or op = "010000" then
			op_alu <= "011010";
		-- not equal(branch bne 1E, 5.1cmpnei)
		elsif op = "011110" or op = "011000" then
			op_alu <= "011011";
		-- equal(branch beq 26, 5.1cmpeqi)
		elsif op = "100110" or op = "100000" then
			op_alu <= "011100";
		-- unsigned <= (branch bleu 2E, 5.1cmpleui)
		elsif op = "101110" or op = "101000" then
			op_alu <= "011101";
		-- unsigned > (branch bleu 36, 5.1cmpgtui)
		elsif op = "110110" or op = "110000" then
			op_alu <= "011110";
		else 
			op_alu <= "000000"; 
		end if;
	end if;
	end process;
	-- v2ChangeEnd
end synth;
