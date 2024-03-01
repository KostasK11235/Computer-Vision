%% Create roi for harley
harley = imread('D:\MatLab_Files\Images\arton29691.jpg');

% Display the image and select the ROI
imshow(harley);
[h, w, ~] = size(harley);
[roi, xi, yi] = roipoly();

% Create a mask for the ROI
harley_mask = poly2mask(xi,yi, h, w);

% Apply the mask to the image
cropped_harley = harley;
cropped_harley(~repmat(harley_mask, [1 1 3])) = 0;

imshow(cropped_harley);

imwrite(cropped_harley, 'D:\MatLab_Files\Images\cropped_harley.jpg');
imwrite(harley_mask, 'D:\MatLab_Files\Images\harley_mask.jpg');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create roi for cat
cat = imread('D:\MatLab_Files\Images\cat.jpg');

% Display the image and select the ROI
imshow(cat);
[h, w, ~] = size(cat);
[roi, xi, yi] = roipoly();

% Create a mask for the ROI
cat_mask = poly2mask(xi,yi, h, w);

% Apply the mask to the image
cropped_cat = cat;
cropped_cat(~repmat(cat_mask, [1 1 3])) = 0;

imshow(cropped_cat);

imwrite(cropped_cat, 'D:\MatLab_Files\Images\cropped_cat.jpg');
imwrite(cat_mask, 'D:\MatLab_Files\Images\cat_mask.jpg');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create roi for dog1
dog1 = imread('D:\MatLab_Files\Images\dog1.jpg');

% Display the image and select the ROI
imshow(dog1);
[h2, w2, ~] = size(dog1);
[roi2, xi2, yi2] = roipoly();

% Create a mask for the ROI
dog1_mask = poly2mask(xi2,yi2, h2, w2);

% Apply the mask to the image
cropped_dog1 = dog1;
cropped_dog1(~repmat(dog1_mask, [1 1 3])) = 0;

imshow(cropped_dog1);

imwrite(cropped_dog1, 'D:\MatLab_Files\Images\cropped_dog1.jpg');
imwrite(dog1_mask, 'D:\MatLab_Files\Images\dog1_mask.jpg');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create roi for dog2
dog2 = imread('D:\MatLab_Files\Images\dog2.jpg');

% Display the image and select the ROI
imshow(dog2);
[h3, w3, ~] = size(dog2);
[roi3, xi3, yi3] = roipoly();

% Create a mask for the ROI
dog2_mask = poly2mask(xi3,yi3, h3, w3);

% Apply the mask to the image
cropped_dog2= dog2;
cropped_dog2(~repmat(dog2_mask, [1 1 3])) = 0;

imshow(cropped_dog2);

imwrite(cropped_dog2, 'D:\MatLab_Files\Images\cropped_dog2.jpg');
imwrite(dog2_mask, 'D:\MatLab_Files\Images\dog2_mask.jpg');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create roi for p200
p200 = imread('D:\MatLab_Files\Images\P200.jpg');

% Display the image and select the ROI
imshow(p200);
[h4, w4, ~] = size(p200);
[roi4, xi4, yi4] = roipoly();

% Create a mask for the ROI
p200_mask = poly2mask(xi4,yi4, h4, w4);

% Apply the mask to the image
cropped_p200= p200;
cropped_p200(~repmat(p200_mask, [1 1 3])) = 0;

imshow(cropped_p200);

imwrite(cropped_p200, 'D:\MatLab_Files\Images\cropped_p200.jpg');
imwrite(p200_mask, 'D:\MatLab_Files\Images\p200_mask.jpg');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('collage_info.mat');
%% Define the pixels shift
shift_left = 1900;
shift_up = 500;

bench = imread('D:\MatLab_Files\Images\bench.jpg');

%% Shift cropped_p200 image -> shift_up
temp = cropped_p200;
shifted_up_p200 = zeros(size(cropped_p200), 'like', cropped_p200);
original_row_indices = (1:size(temp, 1)) - shift_up;
new_row_indices = original_row_indices(original_row_indices > 0 & original_row_indices <= size(temp, 1));

% Copy the image data into the new matrix with the desired vertical offset
shifted_up_p200(new_row_indices, :, :) = temp(new_row_indices + shift_up, :, :);

%% Shift cropped_p200 image -> shift_left
temp = shifted_up_p200;
shifted_p200 = zeros(size(cropped_p200), 'like', cropped_p200);
original_col_indices = (1:size(temp, 2)) - shift_left;
new_col_indices = original_col_indices(original_col_indices > 0 & original_col_indices <= size(temp, 2));

% Copy the image data into the new matrix with the desired horizontal offset
shifted_p200(:, new_col_indices, :) = temp(:, new_col_indices + shift_left, :);

%% Create the shifted_p200_mask and the bench_mask
shifted_p200_mask = zeros(size(p200_mask));
shifted_p200_mask(1:end-shift_up,1:end-shift_left) = p200_mask(shift_up+1:end, shift_left+1:end);
bench_mask = 1 - shifted_p200_mask;

blurh = fspecial('gauss',30,25); % feather the border
maska = imfilter(shifted_p200_mask,blurh,'replicate');
maskb = imfilter(bench_mask,blurh,'replicate');

levels = 5;
lap_p200 = genPyr(shifted_p200,'lap',levels);
lap_bench = genPyr(bench,'lap',levels);

new_img = cell(1,levels); % the blended pyramid
for p = 1:levels
	[Mp Np ~] = size(lap_p200{p});
	maskap = imresize(maska,[Mp Np]);
	maskbp = imresize(maskb,[Mp Np]);
	new_img{p} = lap_p200{p}.*maskap + lap_bench{p}.*maskbp;
end

blended_img = pyrReconstruct(new_img);
figure,imshow(blended_img) % blend by pyramid
blended_img = imresize(blended_img, [2448 3264], 'cubic');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('collage_info.mat');
%% Resize and rotate the image of the cat
small_cat = imresize(cropped_cat, [640 640]);
small_cat = imrotate(small_cat, -65, 'bilinear', 'crop');

shifted_cat = zeros(size(cropped_cat), 'like', cropped_cat);
shifted_cat(1607:2024, 1:450, :) = small_cat(223:end, 191:end, :);

% Create the shifted cat mask and the bench mask
shifted_cat_mask = zeros(size(cat_mask), 'like', cat_mask);
small_cat_mask = imresize(cat_mask, [640 640]);
small_cat_mask = imrotate(small_cat_mask, -65, 'bilinear', 'crop');
shifted_cat_mask(1607:2024, 1:450) = small_cat_mask(223:end, 191:end);
blended_mask = 1 - shifted_cat_mask;

blurh = fspecial('gauss',30,50); % feather the border
maska = imfilter(shifted_cat_mask,blurh,'replicate');
maskb = imfilter(blended_mask,blurh,'replicate');

levels = 5;
lap_cat = genPyr(shifted_cat,'lap',levels);
lap_bench = genPyr(blended_img,'lap',levels);

new_img = cell(1,levels); % the blended pyramid
for p = 1:levels
	[Mp Np ~] = size(lap_p200{p});
	maskap = imresize(maska,[Mp Np]);
	maskbp = imresize(maskb,[Mp Np]);
	new_img{p} = lap_cat{p}.*maskap + lap_bench{p}.*maskbp;
end

blended_img = pyrReconstruct(new_img);
figure,imshow(blended_img) % blend by pyramid
blended_img = imresize(blended_img, [2448 3264], 'cubic');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Resize the image of the dog1
small_dog1 = imresize(cropped_dog1, [1448 2264]);

shifted_dog1 = zeros(size(cropped_dog1), 'like', cropped_dog1);
shifted_dog1(1309:1941, 792:2230, :) = small_dog1(392:1024, 826:end, :);
figure;imshow(shifted_dog1);

% Create the shifted dog1 mask and the bench mask
shifted_dog1_mask = zeros(size(dog1_mask), 'like', dog1_mask);
small_dog1_mask = imresize(dog1_mask, [1448 2264]);
shifted_dog1_mask(1309:1941, 792:2230, :) = small_dog1_mask(392:1024, 826:end, :);
blended_mask = 1 - shifted_dog1_mask;

blurh = fspecial('gauss',30,10); % feather the border
maska = imfilter(shifted_dog1_mask,blurh,'replicate');
maskb = imfilter(blended_mask,blurh,'replicate');

levels = 5;
lap_dog1 = genPyr(shifted_dog1,'lap',levels);
lap_bench = genPyr(blended_img,'lap',levels);

new_img = cell(1,levels); % the blended pyramid
for p = 1:levels
	[Mp Np ~] = size(lap_p200{p});
	maskap = imresize(maska,[Mp Np]);
	maskbp = imresize(maskb,[Mp Np]);
	new_img{p} = lap_dog1{p}.*maskap + lap_bench{p}.*maskbp;
end

blended_img = pyrReconstruct(new_img);
figure,imshow(blended_img) % blend by pyramid
blended_img = imresize(blended_img, [2448 3264], 'cubic');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Resize the image of the dog2
small_dog2 = imresize(cropped_dog2, [1448 2264]);

shifted_dog2 = zeros(size(cropped_dog2), 'like', cropped_dog2);
shifted_dog2(1594:2244, 1874:2600, :) = small_dog2(420:1070,834:1560, :);
figure;imshow(shifted_dog2);

% Create the shifted dog2 mask and the bench mask
shifted_dog2_mask = zeros(size(dog2_mask), 'like', dog2_mask);
small_dog2_mask = imresize(dog2_mask, [1448 2264]);
shifted_dog2_mask(1594:2244, 1874:2600, :) = small_dog2_mask(420:1070,834:1560, :);
blended_mask = 1 - shifted_dog2_mask;

blurh = fspecial('gauss',30,10); % feather the border
maska = imfilter(shifted_dog2_mask,blurh,'replicate');
maskb = imfilter(blended_mask,blurh,'replicate');

levels = 5;
lap_dog2 = genPyr(shifted_dog2,'lap',levels);
lap_bench = genPyr(blended_img,'lap',levels);

new_img = cell(1,levels); % the blended pyramid
for p = 1:levels
	[Mp Np ~] = size(lap_p200{p});
	maskap = imresize(maska,[Mp Np]);
	maskbp = imresize(maskb,[Mp Np]);
	new_img{p} = lap_dog2{p}.*maskap + lap_bench{p}.*maskbp;
end

blended_img = pyrReconstruct(new_img);
figure,imshow(blended_img) % blend by pyramid
blended_img = imresize(blended_img, [2448 3264], 'cubic');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Don't run this all together you will get out of memory error
%% Resize the image of the harley
new_harley = imresize(cropped_harley, [2448 3264]);
small_harley = imresize(cropped_harley, [712 712]);

shifted_harley = zeros(size(new_harley), 'like', new_harley);
shifted_harley(745:1285,1000:1625,:) = small_harley(100:640, 48:673, :);
figure;imshow(shifted_harley);

% Create the shifted harley mask and the bench mask
new_harley_mask = imresize(harley_mask, [2448 3264]);
shifted_harley_mask = zeros(size(new_harley_mask), 'like', new_harley_mask);
small_harley_mask = imresize(new_harley_mask, [712 712]);
shifted_harley_mask(745:1285,1000:1625,:) = small_harley_mask(100:640, 48:673, :);
%shifted_harley_mask(:, 1131:
blended_mask = 1 - shifted_harley_mask;
figure;imshow(small_harley_mask);

blurh = fspecial('gauss',30,1); % feather the border
maska = imfilter(shifted_harley_mask,blurh,'replicate');
maskb = imfilter(blended_mask,blurh,'replicate');

levels = 5;
lap_harley = genPyr(shifted_harley,'lap',levels);
lap_bench = genPyr(blended_img,'lap',levels);

new_img = cell(1,levels); % the blended pyramid
for p = 1:levels
	[Mp Np ~] = size(lap_p200{p});
	maskap = imresize(maska,[Mp Np]);
	maskbp = imresize(maskb,[Mp Np]);
	new_img{p} = lap_harley{p}.*maskap + lap_bench{p}.*maskbp;
end

temp_blended = pyrReconstruct(new_img);
figure,imshow(temp_blended) % blend by pyramid
temp_blended = imresize(temp_blended, [2448 3264], 'cubic');

% Κάτι αποφάσισε να αρχίσει να δουλεύει διαφορετικά μετά από δύο μέρες και έπρεπε
% να κάνω shift την blended εικόνα για να ταιριάζουν τα Pixel με την temp_blended
shifted_blended = zeros(size(blended_img), 'like', blended_img);
original_row_indices = (1:size(blended_img,1)) + 8;
original_col_indices = (1:size(blended_img, 2)) + 6;
new_row_indices = original_row_indices(original_row_indices > 0 & original_row_indices <= size(blended_img, 1));
new_col_indices = original_col_indices(original_col_indices > 0 & original_col_indices <= size(blended_img, 2));

shifted_blended(new_row_indices,new_col_indices,:) = blended_img(new_row_indices - 8,new_col_indices-6,:);
figure;imshow(shifted_blended);

%% Final touches for the image
c = [1123 1612 1612 1000 1000 1121];
r = [1045 1045 1146 1141 719 719];
BW = roipoly(temp_blended,c,r);
BW = ~BW;

c = [1608 1608 1000 1000];
r = [1184 1282 1265 1175];
temp = roipoly(temp_blended,c,r);
temp = ~temp;

temp_mask = ~xor(BW,temp);
blended_mask = 1 - temp_mask;

imshow(temp_blended.*temp_mask)
figure;imshow(blended_img.*blended_mask)

final_img = zeros(size(temp_blended), 'like', temp_blended);
final_img = temp_blended.*temp_mask + shifted_blended.*blended_mask;
imshow(final_img);