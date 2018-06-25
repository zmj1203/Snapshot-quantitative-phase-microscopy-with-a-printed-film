clear all;close all;clc;


%% load data
load checkdata

% H = 4
% W = 5
% 
% mask_gx = zeros(H,W);
% mask_gy = zeros(H,W);
% 
% % mask_gx(2,2) = 1;
% % mask_gx(2,3) = 1;
% % mask_gx(3,2) = 1;
% % mask_gx(3,3) = 1;
% % mask_gy(2,2) = 1;
% % mask_gy(2,3) = 1;
% % mask_gy(3,2) = 1;
% % mask_gy(3,3) = 1;
% %
% % mask_gx(1,1) = 1;
% % mask_gx(2,1) = 1;
% % mask_gy(1,1) = 1;
% % mask_gy(1,2) = 1;
% % 
% % mask_gx(floor(H/4):floor(H/4)+10,:) = 1;
% % mask_gx(H-floor(H/4):H-floor(H/4)+10,:) = 1;
% % mask_gy(:,floor(H/4):floor(H/4)+10) = 1;
% % mask_gy(:,H-floor(H/4):H-floor(H/4)+10) = 1;
% %
% %
% 
% % mask_gx = ones(H,W);
% % mask_gy = ones(H,W);
% 
% % mask_gx(1,:) = 0;
% % mask_gx(end,:) = 0;
% % mask_gy(:,1) = 0;
% % mask_gy(:,end) = 0;
% 
% 
% % mask_gx(2:3,1) = 1;
% % mask_gx(2:3,4) = 1;
% % mask_gy(1,2:4) = 1;
% % mask_gy(3,2:4) = 1;
% 
% 
% % mask_gx(:,3) = 1;
% % mask_gx(1,3) = 0;
% 
% mask_gx = ones(H,W);
% mask_gy = ones(H,W);
% 
% %mask_gx(2,2) = 1;


% WM_1 = randn(H,W);
% WM_1(end,:) = WM_1(end-1,:);
% WM_1(:,end) = WM_1(:,end-1);

% WM_2 = randn(H,W);
% WM_2(end,:) = WM_2(end-1,:);
% WM_2(:,end) = WM_2(:,end-1);



fp = fopen('Debug/mask_gx.txt','wt');
fprintf(fp,'%d\n',W);
fprintf(fp,'%d\n',H);
fprintf(fp,'%d\n',mask_gx);
fclose(fp);

fp = fopen('Debug/mask_gy.txt','wt');
fprintf(fp,'%d\n',W);
fprintf(fp,'%d\n',H);
fprintf(fp,'%d\n',mask_gy);
fclose(fp);

fp = fopen('Debug/WM_1.txt','wt');
fprintf(fp,'%d\n',W);
fprintf(fp,'%d\n',H);
fprintf(fp,'%f\n',WM_1);
fclose(fp);

fp = fopen('Debug/WM_2.txt','wt');
fprintf(fp,'%d\n',W);
fprintf(fp,'%d\n',H);
fprintf(fp,'%f\n',WM_2);
fclose(fp);

%% Display1
 figure;imagesc(mask_gx);colormap gray;
 figure;imagesc(mask_gy);colormap gray;
 

%% Run mst code
mask_gx_saved = mask_gx;
mask_gy_saved = mask_gy;

close all;
myfig(mask_gx);
plot_links1(mask_gx,mask_gy);

mask_gx

[mask_gx,mask_gy] = mst_matlab(H,W,mask_gx_saved,mask_gy_saved,WM_1,WM_2);

mask_gx

myfig(mask_gx);
plot_links1(mask_gx,mask_gy);

keyboard

%% Display2
% figure;imagesc(mask_gx);colormap gray;
% figure;imagesc(mask_gy);colormap gray;

%% Check

im = 80*randn(H,W);
[gx,gy] = calculate_gradients(im,0,0);

[gx1,gy1] = curlcorrection_2d_neumann(gx,gy,mask_gx,mask_gy);

myfig(gx-gx1);title('Error in gx: should be zero');
myfig(gy-gy1);title('Error in gy: should be zero');


