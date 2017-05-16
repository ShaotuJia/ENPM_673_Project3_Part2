%Author: Shaotu Jia
%This script is to use MATLAB computer vision toolbox to find essetial
%matrix and relative camera position

clc;
clear;
close all;

% Load precomputed camera parameters
%load cameraParams.mat

%camera intrinsic matrix
[fx, fy, cx, cy, G_camera_image, LUT] = ReadCameraModel('./stereo/centre','./model');
s = 0; %Axis Skew
K = [fx s cx; 0 fy cy; 0 0 1];

cameraParams = cameraParameters('IntrinsicMatrix', transpose(K));
%format long;
timestamps = dlmread('./model/stereo.timestamps');
FrameNum = length(timestamps(:,1));

%Carmea Position
P = [0;0;0];

%Set of Carmea Position
Set_P = P;

%for k = 2 : FrameNum-1 % The last Frame missed!
for k = 2 : 500
    
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
I1 = UndistortImage(image_1_demo, LUT);
I2 = UndistortImage(image_2_demo, LUT);

%Back rgb image to gray image
%I1 = rgb2gray(image_1_und);
%I2 = rgb2gray(image_2_und);

% Detect feature points
imagePoints1 = detectHarrisFeatures(rgb2gray(I1));

% Create the point tracker
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 5);

% Initialize the point tracker
imagePoints1 = imagePoints1.Location;
initialize(tracker, imagePoints1, I1);

% Track the points
[imagePoints2, validIdx] = step(tracker, I2);
matchedPoints1 = imagePoints1(validIdx, :);
matchedPoints2 = imagePoints2(validIdx, :);

try
% Estimate the fundamental matrix
[E, epipolarInliers] = estimateEssentialMatrix(matchedPoints1, matchedPoints2, cameraParams, 'Confidence', 99.99);

% Find epipolar inliers
inlierPoints1 = matchedPoints1(epipolarInliers, :);
inlierPoints2 = matchedPoints2(epipolarInliers, :);

[orient, loc] = relativeCameraPose(E, cameraParams, inlierPoints1, inlierPoints2);

catch 
    disp('no enough matches');
end

P = P + transpose(loc);
Set_P = horzcat(Set_P, P);

end

figure(1), scatter3(Set_P(1,:),Set_P(2,:),Set_P(3,:),'.','MarkerEdgeColor','b');
title('Position of Carmea Center');
xlabel('X'); % x-axis label
ylabel('Y'); % y-axis label
zlabel('Z'); % z-axis label





