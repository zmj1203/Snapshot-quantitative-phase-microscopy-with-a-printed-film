%clear all;close all;clc;


mask_gx = load('mask_gx_res.txt');
mask_gy = load('mask_gy_res.txt');

W = mask_gx(1);
H = mask_gx(2);
mask_gx = mask_gx(3:end);
mask_gy = mask_gy(3:end);

mask_gx = reshape(mask_gx,H,W);
mask_gy = reshape(mask_gy,H,W);


% figure;imagesc(mask_gx);colormap gray;
% figure;imagesc(mask_gy);colormap gray;

plot_links1(mask_gx,mask_gy)

