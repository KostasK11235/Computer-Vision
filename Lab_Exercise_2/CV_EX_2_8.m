close all;
%% Exercise 2 - Question 7
% Read all the necessary images
beach = rgb2gray(imread('D:\MatLab_Files\Images\beach.jpg'));
ball = rgb2gray(imread('D:\MatLab_Files\Images\ball.jpg'));
ball_mask = rgb2gray(imread('D:\MatLab_Files\Images\ball_mask.jpg'));

ball_mask = imcomplement(ball_mask);
ball = ball_mask - imcomplement(ball);
%% Use imwarp so we can rotate the image by its center
[m,n,~] = size(ball);
tx = floor(m/2);
ty = floor(n/2);
A = [1 0 0; 0 1 0; tx ty 1];
tform = affine2d(A);

[ball,ball_ref] = imwarp(ball,tform,'Interp','cubic','FillValues',0);
[ball_mask,mask_ref] = imwarp(ball_mask,tform,'Interp','cubic','FillValues',0);

%% Scale down the image by 1/4 so it can fit into the beach image
A = [1/4 0 0; 0 1/4 0; 0 0 1];
tform = affine2d(A);

[small_ball,ball_ref] = imwarp(ball,ball_ref,tform,'Interp','cubic','FillValues',0);
[small_mask,mask_ref] = imwarp(ball_mask,mask_ref,tform,'Interp','cubic','FillValues',0);

%% Plot the descending cosine
% length(cosine pulse) + max # of columns of rotated image < # of columns
% of the beach image, also
% max # rows of rotated image + max width of cosine < # of rows 
% of the beach image
N = 500;    % # of samples
step =  0.01;   % time quantum
n = 0:0.01:N*step-step; % discrete time
x = abs(cos(2*pi*n).*exp(-0.25*n));

% the values of the cos will be worldX of the ball image, so because in 
% MatLab matrices index begins from 1 we need to re-assign the x
x(x==0) = 1;

% beach(Am,:,:) is the shore of the beach
% normalize the signal
x = (x-min(x))./(max(x)-min(x));

% multiply with beach height
[M,~,~] = size(beach);
[K,~,~] = size(small_ball);
x = floor(x*(M-(K+K/2)-1));
% x = floor(x);
% plot cosine
% figure('Name','Appropriately Scaled Descending Cosine - Balls Path');
% plot(x);

%% LOOP: Rotation => Translation => Save to temp => Rotation again
% define rotation angle
theta =0;
step = 2;

% define scaling factor
scale_factor = 1; % Initial scaling factor
scale_factor_step = 0.999; % Factor by which the ball shrinks in each step
ball_step = 0.999;
% Number of frames
frames = length(x);
cmap = colormap(gray(256));

% Struct that contains the frames
F(frames) = struct('cdata',[],'colormap',cmap);

tx = zeros(1,frames);
ty = zeros(1,frames);

% For loop to create the video
for i = 1:frames
    %% Update rotation angle
    theta = theta + step;
    x = x.*ball_step;
    % Update scaling factor 
    scale_factor = scale_factor * scale_factor_step;

    % Create affine2d transformation for the rotation
    A_rotate = [cosd(theta) sind(theta) 0;
        -sind(theta) cosd(theta) 0;
        0 0 1];

    % Create affine2d transformation for scaling
    A_scale = [scale_factor 0 0;
                0 scale_factor 0;
                0 0 1];
    A = A_rotate * A_scale;

    tform = affine2d(A');
    [ball_temp] = imwarp(small_ball,ball_ref,tform,'Interp','cubic','FillValues',1);
    [mask_temp] = imwarp(small_mask,mask_ref,tform,'Interp','cubic','FillValues',1);
    %% Place rotated image 
    % get information about the image size and use the center
    % get size of scaled image
    [m,n,~] = size(ball_temp);

    % Calculate the next tx and ty
    tx(i) = max(x) - x(i) + 1;
    ty(i) = 400 - floor(n/2) + 0.5*i;

    % Calculate beach image indices
    xx = [tx(i) tx(i)+m-1];
    yy = [ty(i) ty(i)+n-1];

    %% Create frame
    temp = beach;
    temp(xx(1):xx(2),yy(1):yy(2)) = temp(xx(1):xx(2),yy(1):yy(2)) - mask_temp;
    temp(xx(1):xx(2),yy(1):yy(2)) = temp(xx(1):xx(2),yy(1):yy(2)) + ball_temp;

    %% Update the structure
    F(i) = im2frame(temp,cmap);
end
save('transf_beach_desc.mat','F');
implay(F);