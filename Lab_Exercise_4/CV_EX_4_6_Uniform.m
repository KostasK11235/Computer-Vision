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
noi = 5;
% Number of levels
nol = 1;

% Gauss variance vector and number of iterations for the experement
a = [6 12 18];
N = 100;
L = 2;

%PSNR for high1,high2,low1,low2
PSNRh_1 = zeros(length(a), L);
PSNRh_lk_1 = zeros(length(a), L);

PSNRh_2 = zeros(length(a), L);
PSNRh_lk_2 = zeros(length(a), L);

PSNRl_1 = zeros(length(a), L);
PSNRl_lk_1 = zeros(length(a), L);

PSNRl_2 = zeros(length(a), L);
PSNRl_lk_2 = zeros(length(a), L);
%% Run ecc_lk_allignment for the videos
for j=1:length(a)
    for i=1:L%high1.NumFrames-1
        % High quality video 1
        median = zeros(N,noi);
        median_lk = zeros(N,noi);
        disp(['High1: j=' num2str(j)]);
        tic;
        for k=1:N
            temp = high1.read(i);
            % Uniformly distort the image
            img = high1.read(i+10);
            noise = -a(j)^(1/3)+(a(j)^(1/3)-(-a(j)^(1/3))).*rand(size(img));
            img = uint8(double(img) + (noise));
            [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment...
                (img,temp,nol,noi,'affine',eye(2,3));
            median(k,:) = MSE;
            median_lk(k,:) = MSELK;
        end
        PSNRh_1(j,i) = mean(20*log10(255./mean(median,2)));
        PSNRh_lk_1(j,i) = mean(20*log10(255./mean(median_lk,2)));

        % High quality video 2
        median = zeros(N,noi);
        median_lk = zeros(N,noi);
        disp(['High2: j=' num2str(j)]);
        tic;
        for k=1:N
            temp = high2.read(i);
            % Uniformly distort the image
            img = high2.read(i+10);
            noise = -a(j)^(1/3)+(a(j)^(1/3)-(-a(j)^(1/3))).*rand(size(img));
            img = uint8(double(img) + (noise));
            [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment...
                (img,temp,nol,noi,'affine',eye(2,3));
            median(k,:) = MSE;
            median_lk(k,:) = MSELK;
        end
        PSNRh_2(j,i) = mean(20*log10(255./mean(median,2)));
        PSNRh_lk_2(j,i) = mean(20*log10(255./mean(median_lk,2)));

        % Low quality video 1
        median = zeros(N,noi);
        median_lk = zeros(N,noi);
        disp(['Low1: j=' num2str(j)]);
        tic;
        for k=1:N
            temp = low1.read(i);
            % Uniformly distort the image
            img = low1.read(i+10);
            noise = -a(j)^(1/3)+(a(j)^(1/3)-(-a(j)^(1/3))).*rand(size(img));
            img = uint8(double(img) + (noise));
            [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment...
                (img,temp,nol,noi,'affine',eye(2,3));
            median(k,:) = MSE;
            median_lk(k,:) = MSELK;
        end
        PSNRl_1(j,i) = mean(20*log10(255./mean(median,2)));
        PSNRl_lk_1(j,i) = mean(20*log10(255./mean(median_lk,2)));

        % Low quality video 2
        median = zeros(N,noi);
        median_lk = zeros(N,noi);
        disp(['Low2: j=' num2str(j)]);
        tic;
        for k=1:N
            temp = low2.read(i);
            % Uniformly distort the image
            img = low2.read(i+10);
            noise = -a(j)^(1/3)+(a(j)^(1/3)-(-a(j)^(1/3))).*rand(size(img));
            img = uint8(double(img) + (noise));
            [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment...
                (img,temp,nol,noi,'affine',eye(2,3));
            median(k,:) = MSE;
            median_lk(k,:) = MSELK;
        end
        PSNRl_2(j,i) = mean(20*log10(255./mean(median,2)));
        PSNRl_lk_2(j,i) = mean(20*log10(255./mean(median_lk,2)));
        toc;
    end
end
% Get the mean PSNR for each frame
m_PSNRh_1 = mean(PSNRh_1(:,1:L),2);
m_PSNRh_lk_1 = mean(PSNRh_lk_1(:,1:L),2);
m_PSNRh_2 = mean(PSNRh_2(:,1:L),2);
m_PSNRh_lk_2 = mean(PSNRh_lk_2(:,1:L),2);
m_PSNRl_1 = mean(PSNRl_1(:,1:L),2);
m_PSNRl_lk_1 = mean(PSNRl_lk_1(:,1:L),2);
m_PSNRl_2 = mean(PSNRl_2(:,1:L),2);
m_PSNRl_lk_2 = mean(PSNRl_lk_2(:,1:L),2);
m_PSNR_Uniform = [m_PSNRh_1 m_PSNRh_lk_1 m_PSNRl_1 m_PSNRl_lk_1;
    m_PSNRh_2 m_PSNRh_lk_2 m_PSNRl_2 m_PSNRl_lk_2];
save('CV_EX_4_6_PSNR_uniform.mat','m_PSNR_Uniform');
