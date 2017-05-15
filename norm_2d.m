% Breif: Function translates and normalize a set of 2D homogeneous points 
% so that their centroid is at the origin and their mean distance from 
% the origin is sqrt(2). 
% param: pts the coordinate of points
% param: pts_new the output new points after normalization
% param: T the scale matrix

function [pts_new, T] = norm_2d(pts)

% Find the index of the points that are not at infinity
index = find(abs(pts(3,:)) > eps);
        
% For the points ensure homogeneous coordinates have scale of 1
pts(1,index) = pts(1,index)./pts(3,index);
pts(2,index) = pts(2,index)./pts(3,index);
pts(3,index) = 1;
    
c = mean(pts(1:2,index)')';              % Centroid of points
newOrigin(1,index) = pts(1,index)-c(1);  % Move origin to centroid.
newOrigin(2,index) = pts(2,index)-c(2);
    
dist = sqrt(newOrigin(1,index).^2 + newOrigin(2,index).^2); % distance 

meandist = mean(dist(:));  % the mean distance of new origin
    
scale = sqrt(2)/meandist; % find the scale 
    
T = [scale   0   -scale*c(1) % construct scale matrix 
     0     scale -scale*c(2)
     0       0      1      ];
    
pts_new = T*pts;  % get new normalized points

end