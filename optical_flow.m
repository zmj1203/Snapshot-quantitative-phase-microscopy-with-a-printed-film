function [vx0,vy0]=optical_flow(im1,im2,alpha,save_result,filename)
% 
% Inputs:
%    im1: the reference image
%    im2: the distorted image frame
%    alpha: the regularization weight in optical flow algorithm (default:0.023)
%    save_result: whether or not to save the result images of optical flow  (default:0, i.e., not save)
%    filename: the filename of saving result images
% Outputs:
%    vx0,vy0: the optical flow between reference and distorted images

if nargin<=2
    alpha=0.023;
end
if nargin<=3
    save_result=0;
end

ratio = 1;
minWidth = 20;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;

para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

[vx0,vy0,warpI2] = Coarse2FineTwoFrames(im1,im2,para);
    
if save_result
    path=fullfile('output','optical flow results');
    if ~exist( path, 'dir')
        mkdir(path);
    end
    
    save( fullfile(path,[filename '_vxvy.mat']) ,'vx0','vy0');
    
    % resize image for saving
    if max(size(im1,1),size(im1,2))>750
        temp=max(size(im1,1),size(im1,2))./750;
        temp=1./temp;
        im1=imresize(im1,temp,'bicubic');
        im2=imresize(im2,temp,'bicubic');
        warpI2=imresize(warpI2,temp,'bicubic');
        vx=imresize(vx0,temp,'bicubic');
        vy=imresize(vy0,temp,'bicubic');
        clear temp;
    else
        vx=vx0;
        vy=vy0;
    end
    
    % save results
    volume(:,:,:,1) = im1;
    volume(:,:,:,2) = im2;
    frame2gif1(volume,fullfile(path,[filename '_input.gif']));
    volume(:,:,:,2) = warpI2;
    frame2gif1(volume,fullfile(path,[filename '_warp.gif']));

    flow(:,:,1) = vx;
    flow(:,:,2) = vy;
    imflow = flowToColor(flow);
    imwrite(imflow,fullfile(path,[filename '_flow.jpg']),'quality',100);
end








