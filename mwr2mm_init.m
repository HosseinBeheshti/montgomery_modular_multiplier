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
Q_mwr2mm = MWR2MM_core(K,fixed_point_one,N,max_n_bit,word_length,number_of_pe);
for i = max_n_bit:-1:1
    Q_mwr2mm = MWR2MM_core(Q_mwr2mm,Q_mwr2mm,N,max_n_bit,word_length,number_of_pe);
    if bitget(E,i) == 1
        Q_mwr2mm = MWR2MM_core(P_mwr2mm,Q_mwr2mm,N,max_n_bit,word_length,number_of_pe);
    end
end
enc_msg_mwr2mm = MWR2MM_core(Q_mwr2mm,fixed_point_one,N,max_n_bit,word_length,number_of_pe);

disp_value = ['enc_msg_mwr2mm message is: ',num2str(dec2hex(enc_msg_mwr2mm))];
disp(disp_value)

