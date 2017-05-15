% Author: Shaotu Jia
% Brief: This function is to translation and rotation matrix in essentialMatrix
% param: Ia the first image
% param: Ib the second image
% param: K the camera parameter
% param: S the skew-sysmetric matrix decomposed by Essentail Matrix E
% param: R the rotation matrix decomposed by Essentail Matrix E
% param: t the tranlation matrix decomposd by Essentail Matrix E
% param: n the relative coordinate

function [S, R, t, n] = essentMatrix(Ia, Ib, K)

Ia = single(Ia);
Ib = single(Ib);

[fa, da] = vl_sift(Ia);
[fb, db] = vl_sift(Ib);
[matches, scores] = vl_ubcmatch(da, db) ;

%Get the size of matches
size = length(matches(1,:));

for i = 1 : size
    
    x1_index = matches(1, i);
    x2_index = matches(2, i);
    
    x1(1,i) = fa(1,x1_index);
    x1(2,i) = fa(2,x1_index);

    x2(1,i) = fb(1,x2_index);
    x2(2,i) = fb(2,x2_index);
    
end

% x1 and x2 must be 3D coordinate to find Fundmental matrix so add 1 to
% construct fundmental matrix
x1(3,:) = ones;
x2(3,:) = ones;

%Find fundamental matrix using matched points
F = F_Matrix(x1, x2);

%Essential Matrix
E = transpose(K) * F * K;

%Decompose Essential matrix to translation matrix and rotation matirx
[S, R] = decompose(E, x1, x2, size);

%The translation vector t is the right null space of E since Et = 0
t= null(E);

%The camerea 3D coordinate
n = R*t;

end




