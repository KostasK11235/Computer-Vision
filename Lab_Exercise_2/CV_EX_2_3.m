% Exersise 2 - Question 3

% Read image with white background
pudding = imread('D:\MatLab_Files\Images\pudding.png','BackgroundColor',[1 1 1]);
pudding = im2double(pudding);

% Create a sin function to use for shearing
f = 2;
t = 0:0.01:1-0.01;
x_n = 0.2*sin(2*pi*f*t);

% Define the number of frames and create a struct to store the frames
frames = length(x_n);
F(frames) = struct('cdata',[],'colormap',[]);

[m,n] = size(pudding);

% Shear the image through a loop and add it to the final image
for i=1:frames
    image = ones(m,2*n,3);

    % Create an affine2d object and matrix A
    sh_y = 0;
    sh_x = x_n(i);
    A = [1 sh_x 0;
        sh_y 1 0;
        0 0 1];
    tform = affine2d(A');

    % Scale the image with imwarp
    [im_temp] = imwarp(pudding,tform,'FillValues',1.0);

    % Place image to the right coordinates
    [k,l,~] = size(im_temp);
    start_m = 1;
    end_m = start_m + k-1;
    if(sh_x>0)
        start_n = ceil(n/2)-ceil(m*sh_x);
    else
        start_n = ceil(n/2);
    end
    end_n = start_n + l-1;
    image(start_m:end_m,start_n:end_n,:) = im_temp;

    % Update movie F
    F(i) = im2frame(image,[]);
end


implay(F,40);
%save('sheared_pudding.mat','F');
