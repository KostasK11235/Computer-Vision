% Read videos
hname1="D:\MatLab_Files\Images\video1_high.avi";
hname2="D:\MatLab_Files\Images\video2_high.avi";
lname1="D:\MatLab_Files\Images\video1_low.avi";
lname2="D:\MatLab_Files\Images\video2_low.avi";

high1=VideoReader(hname1);
high2=VideoReader(hname2);
low1=VideoReader(lname1);
low2=VideoReader(lname2);

% Number of iterations 
noi = [10:5:50];
% Number of levels
nol = 1;

% Execution time vectors
t_high1=zeros(length(nol), length(noi));
t_high2=zeros(length(nol), length(noi));
t_low1=zeros(length(nol), length(noi));
t_low2=zeros(length(nol), length(noi));

% PSNR for high1,high2,low1,low2
PSNRh_1 = zeros(length(nol), length(noi));
PSNRh_lk_1 = zeros(length(nol), length(noi));

PSNRh_2 = zeros(length(nol), length(noi));
PSNRh_lk_2 = zeros(length(nol), length(noi));

PSNRl_1 = zeros(length(nol), length(noi));
PSNRl_lk_1 = zeros(length(nol), length(noi));

PSNRl_2 = zeros(length(nol), length(noi));
PSNRl_lk_2 = zeros(length(nol), length(noi));

% Frame number we will use as input image
frame = 88;

% Inititialize the templates and images
temph_1 = high1.read(1);
temph_2 = high2.read(1);
templ_1 = low1.read(1);
templ_2 = low2.read(1);

imgh_1 = high1.read(frame);
imgh_2 = high2.read(frame);
imgl_1 = low1.read(frame);
imgl_2 = low2.read(frame);

% Run ecc_lk_alignment for all the videos
for i=1:length(nol)
    for j=1:length(noi)
        % High quality video 1
        tic;
        [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment...
            (imgh_1,temph_1,i,j,'affine',eye(2,3));
        t_high1(i,j) = toc;
        PSNRh_1(i,j) = mean(20*log10(255./MSE));
        PSNRh_lk_1(i,j) = mean(20*log10(255./MSELK));
        
        % High quality video 2
        tic;
        [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment...
            (imgh_2,temph_2,i,j,'affine',eye(2,3));
        t_high2(i,j) = toc;
        PSNRh_2(i,j) = mean(20*log10(255./MSE));
        PSNRh_lk_2(i,j) = mean(20*log10(255./MSELK));
    
        % Low quality video 1
        tic;
        [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment...
            (imgl_1,templ_1,i,j,'affine',eye(2,3));
        t_low1(i,j) = toc;
        PSNRl_1(i,j) = mean(20*log10(255./MSE));
        PSNRl_lk_1(i,j) = mean(20*log10(255./MSELK));

        % Low quality video 2
        tic;
        [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment...
            (imgl_2,templ_2,i,j,'affine',eye(2,3));
        t_low2(i,j) = toc;
        PSNRl_2(i,j) = mean(20*log10(255./MSE));
        PSNRl_lk_2(i,j) = mean(20*log10(255./MSELK));
    end
end
%% Plot the results
xvector = [1:length(noi)];
% High video for ECC vs LK
figure('Name','PSNR for high video');
semilogy(xvector,PSNRh_1(1,:),xvector,PSNRh_2(1,:),...
    xvector,PSNRh_lk_1(1,:),xvector,PSNRh_lk_2(1,:));
ylabel('PSNR_(dB)');
xlabel('Number of iterations');
title('PSNR for high video');
legend(sprintf('High\\_1\\_ECC\\_nol:%d',1),...
    sprintf('High\\_2\\_ECC\\_nol:%d',1),...
    sprintf('High\\_1\\_LK\\_nol:%d',1),...
    sprintf('High\\_2\\_LK\\_nol:%d',1));
% Low video ECC vs LK
figure('Name','PSNR for low video');
semilogy(xvector,PSNRl_1(1,:),xvector,PSNRl_2(1,:),...
    xvector,PSNRl_lk_1(1,:),xvector,PSNRl_lk_2(1,:));
ylabel('PSNR_(dB)');
xlabel('Number of iterations');
title('PSNR for low video');
legend(sprintf('Low\\_1\\_ECC\\_nol:%d',1),...
    sprintf('Low\\_2\\_ECC\\_nol:%d',1),...
    sprintf('Low\\_1\\_LK\\_nol:%d',1),...
    sprintf('Low\\_2\\_LK\\_nol:%d',1));
% Execution time
figure('Name','Execution time for high video');
semilogy(xvector,t_high1(1,:),xvector,t_high2(1,:),...
    xvector,t_low1(1,:),xvector,t_low2(1,:));
ylabel('Times(sec.)');
xlabel('Number of Iterations');
title('Time execution');
legend(sprintf('High\\_1\\_nol:%d',1),...
    sprintf('High\\_2\\_nol:%d',1),...
    sprintf('Low\\_1\\_nol:%d',1),...
    sprintf('Low\\_2\\_nol:%d',1));
