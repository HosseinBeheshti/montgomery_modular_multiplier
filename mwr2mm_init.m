clear;
close all;
clc;
%%
fs = 250e6;
ts = 1/fs;
max_n_bit = 16; % n
word_length = 4; % w
number_of_pe = ceil((max_n_bit+1)/word_length); % e
simulation_time = ts*(max_n_bit + number_of_pe + 150);
%% simulate
% modulus: 8167
% public key: 4741
% private key: 43f9
% msg: 2f76
% enc_msg: 3c1f
% dec_msg: 2f76

% H-Algorithm
M = fi(hex2dec("2f76"),0,max_n_bit,0);
E = fi(hex2dec("4741"),0,max_n_bit,0);
N = fi(hex2dec("8167"),0,max_n_bit,0);
K = fi(mod((4)^max_n_bit,double(N)),0,max_n_bit,0);
P = MM_core(M,K,N,max_n_bit);
Q = MM_core(K,1,N,max_n_bit);
for i = max_n_bit:-1:1
    Q = MM_core(Q,Q,N,max_n_bit);
    if bitget(E,i) == 1
        Q = MM_core(P,Q,N,max_n_bit);
    end
end
C_T_compute = MM_core(Q,1,N,max_n_bit);

disp_value = ['encrypted message is: ',num2str(dec2hex(C_T_compute))];
disp(disp_value)

