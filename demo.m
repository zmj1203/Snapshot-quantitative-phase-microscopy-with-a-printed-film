clear
clc
close all;

addpath(genpath('data')); % the path of input data % data0
addpath(genpath('OpticalFlow'));
addpath(genpath('AgrawalECCV06CodeMFiles'));

filename_ref=0; % filename of the reference image 
filename_img=[4488:4676];% filename of the distorted images % [4488 4519 4548 4594 4630 4676];%

filename_ref=repmat(filename_ref(:,1),1,size(filename_img,2));
filename_ref=num2str(filename_ref(:),'%06d');
filename_img=num2str(filename_img(:),'%06d');

for i=1:size(filename_img,1)

    if ~exist([ filename_ref(i,:) '.jpg' ],'file') || ~exist([ filename_img(i,:) '.jpg' ],'file')
        continue;
    end
    
    %% load the reference image and distorted image frame
    im1 = im2double(imread( [ filename_ref(i,:) '.jpg' ] )); % reference image
    im2 = im2double(imread( [ filename_img(i,:) '.jpg' ] )); % distorted image frame
    
    im1=im1(35:end,220:2370);
    im2=im2(35:end,220:2370);
    
    %% recover phase by our approach
%    para: the parameter in our approach
%         para.alpha: the regularization weight in optical flow algorithm (default:0.023)
%         para.pixel_size: the pixel size on the focus plane
%         para.distance_sign: the positive and negative sign of defocus distance, which represents 
%                             that the focus plane is above or below the sample plane
%         para.defocus_distance: the distance between the focus plane and sample plane
%         para.n: the refractive index of sample, which is used to convert the phase results to height of sample
%         para.capture_area: the effective capture area in the images
%         para.threshold: the threshold value of optical flow
%         para.filename: the filename of saving results

    disp( ['Input distorted image: ' filename_img(i,:) '.jpg'] );
    para.alpha = 0.023;
    para.pixel_size=0.215;
    para.distance_sign=1;%-1;
    para.defocus_distance=100.*para.distance_sign;
    para.n=4./3;
    para.threshold=0.3;
    para.filename=filename_img(i,:);
    if ~exist('para.capture_area','var')
        if exist(['capture_area.mat'],'file') 
            load('capture_area.mat');
            para.capture_area=capture_area(35:end,220:2370);
            clear capture_area;
        else
            para.capture_area= ones(size(vx))==1;
        end
    end
    
    [phase,vx,vy]=recover_phase(im1,im2,para);
    disp(' ');
    
end

disp('saving the video results...');
save_video(filename_img,para.capture_area);% save the video result of phase to the "output phase video" subfolder in gif format

rmpath(genpath('data'));
rmpath(genpath('data0'));