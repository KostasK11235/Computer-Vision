% Exersise 2 - Question 2 %

% read image in grayscale
ball = rgb2gray(imread('pudding.png'));
[m,n] = size(ball);

% initializing parameters
image = ones(2*m,2*n,1);
scales = randi(100,1,1); % generate number of scales with max=100

% for loop to scale image and place it to overall image
for i=1:scales
    % random scales on axis x and y
    scalex = rand();
    scaley = rand();

    % create an affine2d object
    A = [scalex 0 0; 0 scaley 0; 0 0 1];
    tform = affine2d(A);

    % apply scaling to image
    [im_temp] = imwarp(ball, tform);
    im_temp = im2double(im_temp);

    % generate a valid (x,y) for image to fit
    [k,l,~] = size(im_temp);
    m_new = randi(2*m-k-1,1,1);
    n_new = randi(2*n-l-1,1,1);

    % place image
    mask = im_temp > 0.2;
    image(m_new:m_new+k-1,n_new:n_new+l-1) = mask.*im_temp ...
        + (ones(k,l)-mask).*image(m_new:m_new+k-1,n_new:n_new+l-1);
end
figure;imshow(image);

