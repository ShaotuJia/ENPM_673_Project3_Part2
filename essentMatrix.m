% This script is to match corresponding points
%{
clc;
clear;
close all;

[fx, fy, cx, cy, G_camera_image, LUT] = ReadCameraModel('./stereo/centre','./model');

Ia = imread('1399381444704913.png');
Ib = imread('1399381444767404.png');
%}

%This function is to translation and rotation matrix in essentialMatrix
function [S, R, t, n] = essentMatrix(Ia, Ib, K)

Ia = single(Ia);
Ib = single(Ib);

[fa, da] = vl_sift(Ia);
[fb, db] = vl_sift(Ib);
[matches, scores] = vl_ubcmatch(da, db) ;

% Find the match points close to each other
matches_index = find(scores < 5000000);

%h1 = vl_plotframe(fa(:,6));
%h2 = vl_plotframe(fb(:,8));

%set(h1,'color','k','linewidth',3);
%set(h2,'color','y','linewidth',2);

%{
%The point X to check Camera Matrix
x1_index = matches(1,matches_index(1));
x1(1,1) = fa(1,x1_index);
x1(2,1) = fa(2,x1_index);

x2_index = matches(2,matches_index(2));
x2(1,1) = fb(1, x2_index);
x2(2,1) = fb(2, x2_index);
%}

%Get the size of matches
size = length(matches_index);

for i = 1 : size

    
    x1_index = matches(1,matches_index(i));
    x2_index = matches(2,matches_index(i));
    
    x1(1,i) = fa(1,x1_index);
    x1(2,i) = fa(2,x1_index);

    x2(1,i) = fb(1,x2_index);
    x2(2,i) = fb(2,x2_index);
    
end

x1(3,:) = ones;
x2(3,:) = ones;

%Find fundamental matrix using matched points
[F, e1, e2] = fundmatrix(x1,x2);

%Essential Matrix
E = transpose(K) * F * K;

%Decompose Essential matrix to translation matrix and rotation matirx
[S, R] = decompose(E, x1, x2, size);

%The translation vector t is the right null space of E since Et = 0
t= null(E);

%The camerea coordinate
n = R*t;

W = [0 -1 0; 1 0 0; 0 0 1]; % unimodular Rotation Matrix det(W) = 1
Z = [0 1 0; -1 0 0; 0 0 0]; % unimodular skew symmetric matrix det(Z) = 1

end




