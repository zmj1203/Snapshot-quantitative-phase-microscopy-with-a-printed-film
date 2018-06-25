function height=surface_integration(vx,vy,para)

% 
% Inputs:
%    vx,vy: the optical flow between reference and distorted images 
%    para: the parameter of algorithm
%         para.pixel_size: the pixel size on the focus plane
%         para.distance_sign: the positive and negative sign of defocus distance, which represents 
%                             that the focus plane is above or below the sample plane
%         para.defocus_distance: the distance between the focus plane and sample plane
%         para.n: the refractive index of sample, which is used to convert the phase results to height of sample
%         para.capture_area: the effective capture area in the images
%         para.threshold: the threshold value of optical flow
%         para.filename: the filename of saving result images
% Outputs:
%    height: the height of sample

vx(~para.capture_area)=0;
vy(~para.capture_area)=0;

temp=(abs(vx)>=para.threshold ) | (abs(vy)>=para.threshold);
temp=medfilt2(temp,[30,30]);
vx(~temp)=0;
vy(~temp)=0;

vx1=(vx.*para.pixel_size.*(para.n-1))./(para.defocus_distance+eps);
vy1=(vy.*para.pixel_size.*(para.n-1))./(para.defocus_distance+eps);

[~,fc,~,~,~]=generate_shape(vx1,vy1,[0 1 0 0 0]);
height=fc-min(min(fc(para.capture_area)));
% height(~para.capture_area)=0;

path=fullfile('output','phase image results');
if ~exist( path, 'dir')
    mkdir(path);
end

max_phase=30;
imwrite( (height.*255)./max_phase,jet(255), fullfile(path,[para.filename '_phase_jet.jpg']) );
save( fullfile(path,[para.filename '_phase.mat']), 'height');

% figure(1);
% imshow(height,[0 max_phase]);
% colormap jet(255);
% colorbar



