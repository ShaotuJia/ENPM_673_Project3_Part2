% This is the main script to run program
I = imread('1399381444704913.png');
image = demosaic(I,'grbg');
figure(1), imshow(image);

undistorted = UndistortImage(image, LUT);
figure(2), imshow(undistorted);

