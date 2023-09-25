library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ALU is
   port(
      A:in std_logic_vector(31 downto 0);
      B:in std_logic_vector(31 downto 0);
      s:out std_logic_vector(31 downto 0);
      over:out std_logic;
      cary:out  std_logic;
      contorol:in std_logic_vector(3 downto 0);
      zero:out std_logic
   );
end ALU;
architecture ALU_act of ALU is 
   signal A_temp:unsigned(32 downto 0);
   signal B_temp:unsigned(32 downto 0);
   signal sum :unsigned(32 downto 0); 
   signal over_sum:std_logic;
   signal cary_sum:std_logic; 
   signal sum_u :unsigned(32 downto 0);
   signal cary_sum_u:std_logic;
   signal sub: unsigned(32 downto 0);
   signal over_sub:std_logic;
   signal cary_sub:std_logic;
   signal compliment_B: unsigned(32 downto 0);
   signal zero_line: std_logic;
   signal sub_u: unsigned(32 downto 0);
   signal cary_sub_u :std_logic;
   signal slt: unsigned(31 downto 0);
   signal slt_u: unsigned(31 downto 0);
   signal and_value: unsigned(31 downto 0);
   signal or_value: unsigned(31 downto 0);
   signal nor_value: unsigned(31 downto 0);
   signal xor_value: unsigned(31 downto 0);
   
   begin 
       B_temp(32) <= '0';
       B_temp(31 downto 0)<=unsigned(B(31 downto 0));
       A_temp(32) <= '0';
       A_temp(31 downto 0)<=unsigned(A(31 downto 0));
       ------------------
       sum <= A_temp+B_temp;
       over_sum<= '1' when (sum(31)='1' and A_temp(31)='0' and B_temp(31)='0') or 
		                     (sum(31)='0' and A_temp(31)='1' and B_temp(31)='1') else
              '0';
       cary_sum<= '1' when sum(32)='1' else
              '0';
       ------------------
       sum_u <= sum;
       cary_sum_u <= '1' when sum(32)='1' else
              '0';
       ------------------
       compliment_B(31 downto 0) <= (not B_temp(31 downto 0))+1;
       compliment_B(32) <= '0';
       sub <= A_temp + compliment_B;
       over_sub <= '1' when (sub(31)='1' and A_temp(31)='0' and compliment_B(31)='0') or 
		                      (sub(31)='0' and A_temp(31)='1' and compliment_B(31)='1') else
             '0';
       cary_sub <= '1' when sub(32)='1' else
             '0';
       zero_line <= '1' when A_temp=B_temp else
             '0'; 
      --------------------
       sub_u <= A_temp + compliment_B;
       cary_sub_u <= '1' when sub_u(32)='1' else
             '0';
      --------------------
       slt <= "00000000000000000000000000000001" when (A_temp(31)='0' and B_temp(31)='0' and B_temp(30 downto 0)>A_temp(30 downto 0)) or 
		                                      (B_temp(31)='0' and A_temp(31)='1') or 
						      (A_temp(31)='1' and B_temp(31)='1' and B_temp(30 downto 0)<A_temp(30 downto 0)) else
                                                      "00000000000000000000000000000000";
       slt_u <= "00000000000000000000000000000001" when(B_temp(31 downto 0)>A_temp(31 downto 0))else
              "00000000000000000000000000000000";
       and_value <= A_temp(31 downto 0) and B_temp(31 downto 0);
       or_value <= A_temp(31 downto 0) or B_temp(31 downto 0);
       nor_value <= A_temp(31 downto 0) nor B_temp(31 downto 0);
       xor_value <= A_temp(31 downto 0) xor B_temp(31 downto 0);     
       with contorol select         
       s(31 downto 0)<= std_logic_vector(sum(31 downto 0)) when "0000",
                        std_logic_vector(sum_u(31 downto 0)) when "0001",
                        std_logic_vector(sub(31 downto 0)) when "0010",
                        std_logic_vector(sub_u(31 downto 0)) when "0011", 
                        std_logic_vector(slt) when "0100",
                        std_logic_vector(slt_u) when "0101",
                        std_logic_vector(and_value) when "0110",
                        std_logic_vector(or_value) when "0111",
                        std_logic_vector(nor_value) when "1000",
                        std_logic_vector(xor_value) when others;
       with contorol select  
       over <= over_sum when "0000",
               over_sub when "0010", 
               '0' when others;
       with contorol select  
       cary <= cary_sum when "0000",
                  cary_sum_u when "0001",
                  cary_sub when "0010",
                  cary_sub_u when "0011",
                  '0' when others;
       with contorol select  
       zero <= zero_line when "0010",
                  '0' when others;
       
   end ALU_act;
