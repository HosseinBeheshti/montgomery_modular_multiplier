function Z = MWR2MM_core(X,Y,M,max_n_bit,word_length,number_of_pe)
S = fi(hex2dec("0"),0,max_n_bit,0);
single_bit_word = fi(hex2dec("0"),0,1,0);
two_bit_word = fi(hex2dec("0"),0,2,0);
q = zeros(max_n_bit,1,'like',single_bit_word);
Word_cell = fi(hex2dec("0"),0,word_length,0);
M_e = zeros(number_of_pe,1,'like',Word_cell);
Y_e = zeros(number_of_pe,1,'like',Word_cell);
S_e = zeros(number_of_pe,1,'like',Word_cell);
C_e = zeros(number_of_pe+1,1,'like',two_bit_word);

for k=1:number_of_pe-1
    M_e(k) = bitsliceget(M,(k)*word_length,(k-1)*word_length+1);
    Y_e(k) = bitsliceget(Y,(k)*word_length,(k-1)*word_length+1);
    S_e(k) = bitsliceget(S,(k)*word_length,(k-1)*word_length+1);
end

for i=1:max_n_bit
    q(i) = bitxor(bitand(bitget(X,i),bitget(Y_e(1),1)),bitget(S_e(1),1));
    temp_value = bitsliceget(bitget(X,i)*Y_e(1),word_length,1)+bitsliceget(q(i)*M_e(1),word_length,1)+S_e(1);
    S_e(1) = bitsliceget(temp_value,word_length,1);
    C_e(2) = bitsliceget(temp_value,word_length+2,word_length+1);
%                     before = ['before S_e(1): ',num2str(double(S_e(1))),'        '];
    for j=2:number_of_pe
        temp_value2 = C_e(j)+bitsliceget(bitget(X,i)*Y_e(j),word_length,1)+bitsliceget(q(i)*M_e(j),word_length,1)+S_e(j);
        S_e(j) = bitsliceget(temp_value2,word_length,1);
        C_e(j+1) = bitsliceget(temp_value2,word_length+2,word_length+1);
        S_e(j-1) = bitconcat(bitget(S_e(j),1),bitsliceget(S_e(j-1),word_length,2));
    end
    S_e(number_of_pe) = 0;
            disp_value = ['S_e(1):',num2str(double(S_e(1))),'   S_e(2):',num2str(double(S_e(2))),'  S_e(3):',num2str(double(S_e(3))),'  S_e(4):',num2str(double(S_e(4)))];
    disp(disp_value)

end
Z_temp1 = zeros(1,1,'like',single_bit_word);
for i=1:number_of_pe-1
    Z_temp1 = bitconcat(S_e(i),Z_temp1);
end
Z_temp1 = bitsliceget(Z_temp1,max_n_bit+1,2);
if Z_temp1 > M
    Z_temp2 = Z_temp1-M;
else
    Z_temp2 = Z_temp1;
end
Z = bitsliceget(Z_temp2,max_n_bit,1);
end