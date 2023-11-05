% Exercise 2 - Question 5
% Read all the nessecery images
windmill = im2double(rgb2gray(imread('windmill_back.jpeg')));
blades = im2double(rgb2gray(imread('windmill.png')));
blades_mask = im2double(rgb2gray(imread("windmill_mask.png")));

% Number of frames
frames = 240;
cmap = [];

% Struct that contains the frames
F(frames) = struct('cdata',[],'colormap',cmap);
[m,n,~] = size(blades);
theta = 0;
step = 2;

% Create an affine2d object 
tx = ceil(m/2);
ty = ceil(n/2);
A = [1 0 0; 0 1 0; tx ty 1];

tform = affine2d(A);

% Use imwarp to center the image
[blades] = imwarp(blades,tform,'Interp','linear','FillValues',1);
[blades_mask,imref_temp] = imwarp(blades_mask,tform,'Interp','linear','FillValues',1);

% For loop to create the video
for i = 1:frames
    % Create the background
    image = windmill;
    % Create an affine2d tranformations that will rotate the blades
    A = [cosd(theta) -sind(theta) 0;
        sind(theta) cosd(theta) 0;
        0 0 1];

    tform = affine2d(A');
    [im] = imwarp(blades,imref_temp,tform,'Interp','Cubic','FillValues',1);
    [im_mask] = imwarp(blades_mask,imref_temp,tform,'Interp','Cubic',...
        'FillValues',1);

    % Place the image on the coordinates [X,Y] = [665,434] on windmill
    % background
    [m,n,~] = size(im);
    mask = im_mask > 0.1;
    start_n = 665 - ceil(n/2);
    end_n = start_n + n - 1;
    start_m = 434 - ceil(m/2);
    end_m = start_m + m -1;
    image(start_m:end_m,start_n:end_n) = (ones(size(im)) - mask).*im...
        +mask.*image(start_m:end_m,start_n:end_n);

    % increase theta
    theta = theta + step;

    F(i) = im2frame(im2uint8(image),gray(256));
end

implay(F,40)