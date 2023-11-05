% Exercise 2 - Question 7
% Read all the nessecery images
beach = im2double(rgb2gray(imread('beach.jpg')));
ball = im2double(rgb2gray(imread('ball.jpg')));
ball_mask = im2double(rgb2gray(imread('ball_mask.jpg')));

% Number of frames
frames = length(x_n);

% Create a sin function to use for shearing
f = 2;
t = 0:0.01:1-0.01;
x_n = 0.2*cos(2*pi*f*t);

% Re-shape the ball so it can fit into the beach image
A = [1/4 0 0; 0 1/4 0; 0 0 1];
tform = affine2d(A);
[ball] = imwarp(ball,tform);
[ball_mask] = imwarp(ball_mask,tform);

% Struct that contains the frames
F(frames) = struct('cdata',[],'colormap',[]);
[m,n,~] = size(ball);
theta = 0;
step = 2;

% Create an affine2d object
tx = ceil(m/2);
ty = ceil(n/2);
A = [1 0 0; 0 1 0; tx ty 1];

tform = affine2d(A);

% Center the image with imwarp
[ball] = imwarp(ball,tform,'Interp','linear','FillValues',1);
[ball_mask,imref_temp] = imwarp(ball_mask,tform,'Interp','linear','FillValues',1);

% For loop to create the video
for i = 1:frames
    image = beach;

    % Rotate the ball
    A = [cosd(theta) -sind(theta) 0;
        sind(theta) cosd(theta) 0;
        0 0 1];

    tform = affine2d(A');
    [im] = imwarp(ball, imref_temp,tform,'Interp','Linear','FillValues',1);
    [im_mask,imref] = imwarp(ball_mask,imref_temp,tform,'Interp','Linear',...
        'FillValues',1);

    sh_y = 0;
    sh_x = x_n(i);
    A = [1 0 0;
        0 1 0;
        sh_x sh_y 1];
    tform = affine2d(A');

    [im] = imwarp(ball, imref_temp,tform,'Interp','Linear','FillValues',1);
    [im_mask,imref] = imwarp(ball_mask,imref_temp,tform,'Interp','Linear',...
        'FillValues',1);

    % Place the image on the coordinates [X,Y] = [767,352] on windmill
    % background
    [m,n,~] = size(im);
    mask = im_mask > 0.1;
    start_n = 846 - ceil(n/2);
    end_n = start_n + n - 1;
    start_m = 400 - ceil(m/2);
    end_m = start_m + m -1;
    image(start_m:end_m,start_n:end_n) = (ones(size(im)) - mask).*im...
        +mask.*image(start_m:end_m,start_n:end_n);

    theta = theta + step;

    F(i) = im2frame(im2uint8(image),gray(256));
end
implay(F,40);