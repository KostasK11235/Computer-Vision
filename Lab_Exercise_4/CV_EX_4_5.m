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
noi = 10;
% Number of levels
nol = 2;

% PSNR for high1,high2,low1,low2
PSNRh_1 = zeros(1,high1.NumFrames-1);
PSNRh_lk_1 = zeros(1,high1.NumFrames-1);

PSNRh_2 = zeros(1,high2.NumFrames-1);
PSNRh_lk_2 = zeros(1,high2.NumFrames-1);

PSNRl_1 = zeros(1,low1.NumFrames-1);
PSNRl_lk_1 = zeros(1,low1.NumFrames-1);

PSNRl_2 = zeros(1,low2.NumFrames-1);
PSNRl_lk_2 = zeros(1,low2.NumFrames-1);

%% Run ecc_lk_allignment for the videos
for i=1:high1.NumFrames-10
    % High quality video 1
    temp = double(high1.read(i)) + randi([-2 2],256,256);
    img = double(high1.read(i+10)) + randi([-2 2],256,256);
    [~,~,MSE,~,MSELK] = ecc_lk_alignment(img,temp,nol,noi,'affine',eye(2,3));
    PSNRh_1(i) = mean(20*log10(255./MSE));
    PSNRh_lk_1(i) = mean(20*log10(255./MSELK));

    % High quality video 2
    temp = double(high2.read(i)) + randi([-2 2],256,256);
    img = double(high2.read(i+10)) + randi([-2 2],256,256);
    [~,~,MSE,~,MSELK] = ecc_lk_alignment(img,temp,nol,noi,'affine',eye(2,3));
    PSNRh_2(i) = mean(20*log10(255./MSE));
    PSNRh_lk_2(i) = mean(20*log10(255./MSELK));

    % Low quality video 1
    temp = double(low1.read(i)) + randi([-2 2],64,64);
    img = double(low1.read(i+10)) + randi([-2 2],64,64);
    [~,~,MSE,~,MSELK] = ecc_lk_alignment(img,temp,nol,noi,'affine',eye(2,3));
    PSNRl_1(i) = mean(20*log10(255./MSE));
    PSNRl_lk_1(i) = mean(20*log10(255./MSELK));

    % High quality video 1
    temp = double(low2.read(i)) + randi([-2 2],64,64);
    img = double(low2.read(i+10)) + randi([-2 2],64,64);
    [~,~,MSE,~,MSELK] = ecc_lk_alignment(img,temp,nol,noi,'affine',eye(2,3));
    PSNRl_2(i) = mean(20*log10(255./MSE));
    PSNRl_lk_2(i) = mean(20*log10(255./MSELK));
end

m_PSNRh_1 = mean(PSNRh_1);
m_PSNRh_lk_1 = mean(PSNRh_lk_1);
m_PSNRh_2 = mean(PSNRh_2);
m_PSNRh_lk_2 = mean(PSNRh_lk_2);

m_PSNRl_1 = mean(PSNRl_1);
m_PSNRl_lk_1 = mean(PSNRl_lk_1);
m_PSNRl_2 = mean(PSNRl_2);
m_PSNRl_lk_2 = mean(PSNRl_lk_2);

m_PSNR = [m_PSNRh_1 m_PSNRh_lk_1 m_PSNRh_2 m_PSNRh_lk_2;
    m_PSNRl_1 m_PSNRl_lk_1 m_PSNRl_2 m_PSNRl_lk_2];
save('CV_EX_4_5_m_PSNR_both_2_lvls.mat','m_PSNR');
%% Plot the results
xvector = (1:high1.NumberOfFrames-1);
% High video ECC and LK
figure('Name','PSNR for high quality video');
semilogy(xvector,PSNRh_1,'-+b');hold on;semilogy(xvector,PSNRh_2,'-+r');
semilogy(xvector,PSNRh_lk_1,'-+k');semilogy(xvector,PSNRh_lk_2,'-+g');
ylabel('PSNR_(dB)');xlabel('Time');
title('PSNR for high video');
legend('High\_1\_ECC','High\_2\_ECC','High\_1\_LK','High\_2\_LK');
% Low video ECC and LK
figure('Name','PSNR for low quality video');
semilogy(xvector,PSNRl_1,'-+b');hold on;semilogy(xvector,PSNRl_2,'-+r');
semilogy(xvector,PSNRl_lk_1,'-+k');semilogy(xvector,PSNRl_lk_2,'-+g');
ylabel('PSNR_(dB)');xlabel('Time');
title('PSNR for low video');
legend('Low\_1\_ECC','Low\_2\_ECC','Low\_1\_LK','Low\_2\_LK');
% High and Low ECC and LK
figure('Name','PSNR for all videos');
semilogy(xvector,PSNRh_1,'-+',xvector,PSNRh_2,'-+',xvector,PSNRh_lk_1,'-+',...
    xvector,PSNRh_lk_2,'-+',xvector,PSNRl_1,'-+',xvector,PSNRl_2,'-+',...
    xvector,PSNRl_lk_1,'-+',xvector,PSNRl_lk_2,'-+');
ylabel('PSNR_(dB)');xlabel('Time');
title('PSNR for all videos');
legend('High\_1\_ECC','High\_2\_ECC','High\_1\_LK','High\_2\_LK',...
    'Low\_1\_ECC','Low\_2\_ECC','Low\_1\_LK','Low\_2\_LK');