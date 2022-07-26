function Z = MM_core(X,Y,M,n)
S = fi(hex2dec("0"),0,n,0);
for i=1:n
    q_i = bitxor(bitand(bitget(X,i),bitget(Y(1),1)),bitget(S(1),1));
    S = bitsliceget((S+bitget(X,i)*Y+q_i*M)/2,n,1);
end
if S>M
    Z = S-M;
else
    Z = S;
end
end