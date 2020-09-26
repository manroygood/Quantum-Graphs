function tau=detSign(M)
% rather than try to calculate the determinant, which for a large matrix is
% likely to return the value inf, we just compute its sign. Since in the
% LUP decomposition, det(L)=1, 
[~,U,P]=lu(M);
uu=prod(sign(diag(U)));
pp=det(P);
tau=uu*pp;
