%This function is to decompose Esstential Matrix E to Translation Vector t and
%Rotation Matrix R
% x1 and x2 are the corresponding points of X in two images

function [S, R] = decompose(E, x1, x2, size)

R = 0;
S = 0;

W = [0 -1 0; 1 0 0; 0 0 1]; % unimodular Rotation Matrix det(W) = 1
Z = [0 1 0; -1 0 0; 0 0 0]; % unimodular skew symmetric matrix det(Z) = 1

[U,Sigma,V] = svd(E); % SVD decompose

S1 = -U * Z * transpose(U);
R1 = U * transpose(W) * transpose(V);

S2 = U * Z * transpose(U);
R2 = U * W * transpose(V);

% Identity Matrix I
I = eye(3);
zeroColumn = [0;0;0];
P1 = horzcat(I,zeroColumn);

% The third column of matrix U
u3 = U(:,3);

%Lamda = 1
P2_1 = horzcat(U*W*V, u3);
P2_2 = horzcat(U*transpose(W)*V, u3);

%Lamda = -1
P2_3 = horzcat(U*W*V, -u3);
P2_4 = horzcat(U*transpose(W)*V, -u3);

for j = 1 : size
%reconstruct point X using x1 and x2
A1 = [x1(1,j)*P1(3,:)-P1(1,:); x1(2,j)*P1(3,:)-P1(2,:); x2(1,j)*P2_1(3,:)-P2_1(1,:); x2(2,j)*P2_1(3,:)-P2_1(2,:)];

A2 = [x1(1,j)*P1(3,:)-P1(1,:); x1(2,j)*P1(3,:)-P1(2,:); x2(1,j)*P2_2(3,:)-P2_2(1,:); x2(2,j)*P2_2(3,:)-P2_2(2,:)];

A3 = [x1(1,j)*P1(3,:)-P1(1,:); x1(2,j)*P1(3,:)-P1(2,:); x2(1,j)*P2_3(3,:)-P2_3(1,:); x2(2,j)*P2_3(3,:)-P2_3(2,:)];

A4 = [x1(1,j)*P1(3,:)-P1(1,:); x1(2,j)*P1(3,:)-P1(2,:); x2(1,j)*P2_4(3,:)-P2_4(1,:); x2(2,j)*P2_4(3,:)-P2_4(2,:)];

% Point X is the singular vector with smallest singular value
[U1, D1, V1] = svd(A1);
[U2, D2, V2] = svd(A2);
[U3, D3, V3] = svd(A3);
[U4, D4, V4] = svd(A4);

%{
[M1 N1] = min(diag(D1));
[M2 N2] = min(diag(D2));
[M3 N3] = min(diag(D3));
[M4 N4] = min(diag(D4));
%}

X1 = V1(:,4);
X2 = V2(:,4);
X3 = V3(:,4);
X4 = V4(:,4);

%{
% Solve X since AX = 0, X is right null space of A
X1 = null(A1);
X2 = null(A2);
X3 = null(A3);
X4 = null(A4);

if ~isempty(X1) || ~isempty(X2) || ~isempty(X3) || ~isempty(X4)
    disp('j = ');
    disp(j);
end
%}

% The X point must be in front of camrea; Find the R and S let X point in
% front of the camrea
if ~isempty(X1) && (X1(3)/X1(4))>0 
    X = X1;
    R = R2;
    S = S2;
    %disp('X = ');
    %disp(X);
    break;
end

if ~isempty(X2) && (X2(3)/X2(4))>0 
    X = X2;
    R = R1;
    S = S2;
    %disp('X = ');
    %disp(X);
    break;
end

if ~isempty(X3) && (X3(3)/X3(4))>0 
    X = X3;
    R = R2;
    S = S1;
    %disp('X = ');
    %disp(X);
    break;
end

if ~isempty(X4) && (X4(3)/X4(4))>0 
    X = X4;
    R = R1;
    S = S1;
    %disp('X = ');
    %disp(X);
    break;
end

end


end
