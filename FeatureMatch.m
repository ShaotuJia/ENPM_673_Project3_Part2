% This script is to match corresponding points
clc;
clear;
close all;

[fx, fy, cx, cy, G_camera_image, LUT] = ReadCameraModel('./stereo/centre','./model');

Ia = imread('1399381444704913.png');
Ib = imread('1399381444767404.png');

Ia = single(Ia);
Ib = single(Ib);

[fa, da] = vl_sift(Ia);
[fb, db] = vl_sift(Ib);
[matches, scores] = vl_ubcmatch(da, db) ;

h1 = vl_plotframe(fa(:,6));
h2 = vl_plotframe(fb(:,8));

%set(h1,'color','k','linewidth',3);
%set(h2,'color','y','linewidth',2);

%Get the size of matches
size = length(matches(1,:));

for i = 1 : size

    x1_index = matches(1,i);
    x2_index = matches(2,i);
    
    x1(1,i) = fa(1,x1_index);
    x1(2,i) = fa(2,x1_index);

    x2(1,i) = fb(1,x2_index);
    x2(2,i) = fb(2,x2_index);
    
end

x1(3,:) = ones;
x2(3,:) = ones;

%!!!check whether F is fundamental matrix; may be esstential matrix
[F e1 e2] = fundmatrix(x1,x2);

%camera intrinsic matrix
s = 0; %Axis Skew
K = [fx s cx; 0 fy cy; 0 0 1];

%Essential Matrix
E = transpose(K) * F * K;


