% This is the main script to run program
%{
I = imread('1399381444704913.png');
image = demosaic(I,'grbg');
figure(1), imshow(image);

undistorted = UndistortImage(image, LUT);
figure(2), imshow(undistorted);
%}

clc;
clear;
close all;

%camera intrinsic matrix
[fx, fy, cx, cy, G_camera_image, LUT] = ReadCameraModel('./stereo/centre','./model');
s = 0; %Axis Skew
K = [fx s cx; 0 fy cy; 0 0 1];

%format long;
timestamps = dlmread('./model/stereo.timestamps');

FrameNum = length(timestamps(:,1));

%Carmea Position
P = [0;0;0];

%Set of Carmea Position
Set_P = P;

for k = 2 : FrameNum
%for k = 2 : 2
    
imageNum_1 = num2str(timestamps(k-1,1));
imageNum_2 = num2str(timestamps(k,1));
imageName_1 = strcat('stereo/','centre/',imageNum_1,'.png');
imageName_2 = strcat('stereo/','centre/',imageNum_2,'.png');

image_1 = imread(imageName_1);
image_2 = imread(imageName_2);

%recover image to grbg image using demosaic
image_1_demo = demosaic(image_1,'grbg');
image_2_demo = demosaic(image_2,'grbg');

%Undistort image
image_1_und = UndistortImage(image_1_demo, LUT);
image_2_und = UndistortImage(image_2_demo, LUT);

%Back rgb image to gray image
image_1_gray = rgb2gray(image_1_und);
image_2_gray = rgb2gray(image_2_und);

%figure(1), imshow(image_1_gray);
%figure(2), imshow(image_2_gray);

[S, R, t, n] = essentMatrix(image_1_gray, image_2_gray, K);

%update the position of carmea center
P = P + n;

%plot the position fo carmea center and assume the initial position of
%carmea is (0,0,0)
%figure(1), title('Position of Carmea Center');
%scatter3(P(1),P(2),P(3),'.','MarkerEdgeColor','k');
%hold on;
Set_P = horzcat(Set_P, P);
end

figure(1), scatter3(Set_P(1,:),Set_P(2,:),Set_P(3,:),'.','MarkerEdgeColor','b');
title('Position of Carmea Center');
xlabel('X'); % x-axis label
ylabel('Y'); % y-axis label
zlabel('Z'); % z-axis label
