clear;
close all;
clc;
%%
fs = 250e6;
ts = 1/fs;
max_n_bit = 16; % n
word_length = 4; % w
number_of_pe = ceil((max_n_bit+1)/word_length); % e
maximum_latency = 2*max_n_bit*(max_n_bit+number_of_pe-1)*ts;
simulation_time = maximum_latency*3;
%% 1024 bit test
% modulus: b887557865fb44ead883b3e1533cf407ce47ab478ac84497d83a8182fc9839e3c4b57421e525b1769f18387f534e4642f6814cf01336f43b6c09eb4926f74bf22b735691c0532c1f4b6e047ec5432e8b398e475dd32630711120c60150bdee32760fbdcd6c58b382ada0391d087bbc9b11ca4a11bbfc4a8ca0e9a4a4dc474a5f
% public key: 3783b72a7a0e752da50afff08135499c89711b1fc070375bacd8308aa36630c1cc1753411d87d8a078538c1fef9e37b4f9115a943a30cee65541f0b4662f3d7deafa90ef4c8dac74ec9b617fc5422e47cd70758a020174a4be928e90a0f007f48e6f5ab83e979986ac8f430a66e73f35ec2c3d5a67283dfb498378e159fac90d
% private key: 1d36a18ba5e54a3114da4a53b73160d043daf215c308b0303dad4809c7707767b2ce6a42557e3ba32f0a2948e53247a33ebc3ada42c72821b4a63a7569014bdd0ec08d99c4e57dc1564c72a8d2c3f87a0609ce8caf475c2ebaad50573f806e16fd31d8d3de7a898c1ec02004deecfbbf0887d49f5c337c8ff270969a39d859f5
% msg: 6cfa9bca136210fca9ad664f8c8220eeead82e992b630f95f0dd2e74c506931d7a2fe9a7f10130efeabc566f4765618e9c853dc1c81b7905cd434f08a1b4e6b262fe657228327b7c6ba842fa663b5f14273d3a47c1aeeb76d97e8b748f222111a8ea8367b67196ce1a81318020b94ed07dcca47d27dd7e7b8c8b62ec0d0198df
% enc_msg: 95ba39c79655cdc5f956d729fbc998d1be90e392881b8b605befec536b58b4c52d9ea9da6049145958a5a584daa4f8faeabcb8e325d7cd61092b8e41e01a6374da488c0a8b73c9b63b9b1bef409e0883e2be4c8f9de76c92ebfd687c8a82d3da16db4892f6a91e5ce080b0e8c8d2617e086b75580b9ea5c5971477e3353b7dab
% dec_msg: 6cfa9bca136210fca9ad664f8c8220eeead82e992b630f95f0dd2e74c506931d7a2fe9a7f10130efeabc566f4765618e9c853dc1c81b7905cd434f08a1b4e6b262fe657228327b7c6ba842fa663b5f14273d3a47c1aeeb76d97e8b748f222111a8ea8367b67196ce1a81318020b94ed07dcca47d27dd7e7b8c8b62ec0d0198df

%% simulate 16 bit 
% modulus: 8167
% public key: 4741
% private key: 43f9
% msg: 2f76
% enc_msg: 3c1f
% dec_msg: 2f76

% H-Algorithm
fixed_point_one = fi(hex2dec("1"),0,max_n_bit,0);
M = fi(hex2dec("2f76"),0,max_n_bit,0);
E = fi(hex2dec("4741"),0,max_n_bit,0);
N = fi(hex2dec("8167"),0,max_n_bit,0);
K = fi(mod((4)^max_n_bit,double(N)),0,max_n_bit,0);
Q = zeros(max_n_bit,1,'like',K);

% implementation with MM_core
P = MM_core(M,K,N,max_n_bit);
Q = MM_core(K,1,N,max_n_bit);
for i = max_n_bit:-1:1
    Q = MM_core(Q,Q,N,max_n_bit);
    if bitget(E,i) == 1
        Q = MM_core(P,Q,N,max_n_bit);
    end
end
enc_msg_mn = MM_core(Q,1,N,max_n_bit);

disp_value = ['enc_msg_mn message is: ',num2str(dec2hex(enc_msg_mn))];
disp(disp_value)

% implementation with  MWR2MM_core
P_mwr2mm = MWR2MM_core(M,K,N,max_n_bit,word_length,number_of_pe);
Q_mwr2mm = MWR2MM_core(fixed_point_one,K,N,max_n_bit,word_length,number_of_pe);
for i = max_n_bit:-1:1
    Q_mwr2mm = MWR2MM_core(Q_mwr2mm,Q_mwr2mm,N,max_n_bit,word_length,number_of_pe);
    if bitget(E,i) == 1
        Q_mwr2mm = MWR2MM_core(P_mwr2mm,Q_mwr2mm,N,max_n_bit,word_length,number_of_pe);
    end
end
enc_msg_mwr2mm = MWR2MM_core(Q_mwr2mm,fixed_point_one,N,max_n_bit,word_length,number_of_pe);

disp_value = ['enc_msg_mwr2mm message is: ',num2str(dec2hex(enc_msg_mwr2mm))];
disp(disp_value)
