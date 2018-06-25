function [height,vx,vy]=recover_phase(im1,im2,para)

% 
% Inputs:
%    im1: the reference image
%    im2: the distorted image frame
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
% Outputs:
%    height: the height of sample
%    vx,vy: the optical flow between reference and distorted images

%% estimate distortion by optical flow
disp('  Estimating the distortion...');
[vx,vy]=optical_flow(im1,im2,para.alpha);

%% surface integration
disp('  Surface integration...');
height=surface_integration(vx,vy,para);