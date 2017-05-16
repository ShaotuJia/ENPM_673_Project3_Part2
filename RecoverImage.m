% recover image to rgb

%camera intrinsic matrix
[fx, fy, cx, cy, G_camera_image, LUT] = ReadCameraModel('./stereo/centre','./model');
%format long;
timestamps = dlmread('./model/stereo.timestamps');
for i = 120 : 2 : 300
imageNum = num2str(timestamps(i,1));
imageName = strcat('stereo/','centre/',imageNum,'.png');

image = imread(imageName);
image = demosaic(image,'grbg');
image = UndistortImage(image, LUT);

NumStr = num2str(i);
newName = strcat('sample/',NumStr,'.png');
imwrite(image,newName);

end