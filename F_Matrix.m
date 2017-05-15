% Author: Shaotu Jia
% Breif: This function is to find the fundamental matrix F given corrsponding
% points x1 and x1. x1 and x2 must be 3D coordinates. The computation of fundmental matrix based on 8 points alogrithm given by
% Hartley and Zisserman 
% param: x1 the matched points in first image
% param: x2 the matched points in second image
% param: F the fundmental matrix

function F = F_Matrix(x1, x2)

if length(x1(:,1)) < 3
    error(' point must be 3D coordinate');
end

ptsNum = length(x1(1,:)); % find the number of points

if ptsNum < 8
    error('the number of points must be more 8');
end

[x1, T1] = norm_2d(x1);
[x2, T2] = norm_2d(x2);

% A is the constriant matrix
A = [x2(1,:)'.*x1(1,:)'   x2(1,:)'.*x1(2,:)'  x2(1,:)' ...
     x2(2,:)'.*x1(1,:)'   x2(2,:)'.*x1(2,:)'  x2(2,:)' ...
     x1(1,:)'             x1(2,:)'            ones(ptsNum,1) ]; 

[U,D,V] = svd(A,0); % Find the SVD using economy decomposition

% Extract fundamental matrix from the column of V corresponding to
% smallest singular value.
F = reshape(V(:,9),3,3)';

% Enforce constraint that fundamental matrix has rank 2 by performing
% a svd and then reconstructing with the two largest singular values.
[U,D,V] = svd(F,0);
F = U*diag([D(1,1) D(2,2) 0])*V';

% Denormalise
F = T2'*F*T1;

end