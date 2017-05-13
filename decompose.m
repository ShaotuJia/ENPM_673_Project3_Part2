%This function is to decompose Esstential Matrix E to Translation Vector t and
%Rotation Matrix R

function [t R] = decompose(E)

W = [0 -1 0; 1 0 0; 0 0 1]; % unimodular Rotation Matrix det(W) = 1
Z = [0 1 0; -1 0 0; 0 0 0]; % unimodular skew symmetric matrix det(Z) = 1

[U,S,V] = svd(E) % SVD decompose

S1 = -U * Z * transpose(U);
R1 = U * transpose(W) * transpose(V);

S2 = U * Z * transpose(U);
R2 = U * W * transpose(V);

if Valid_RS(S1,R1) 
    S = S1;
    R = R1;
    



end
