% Ερώτημα B_2
clear all;
load('img.mat');
img = uint8(img);
frames = 2;
% Struct containing all the frames
video(frames) = struct('cdata',[],'colormap',[]);
% insert frames to img1
video(1) = im2frame(img,gray(256));
video(2) = im2frame(img,gray(256));
