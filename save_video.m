function save_video(filename_img,capture_area)

% save the phase video results to the "output phase video" subfolder in gif format

delaytime=0.1; % the frame rate of output gif image
max_phase=30; % the maximum value of phase 

ii=0;
for i=1:size(filename_img,1)
    if ~exist( fullfile('output','phase image results',[filename_img(i,:) '_phase.mat']),'file')
        continue;
    end
    
    load( fullfile('output','phase image results',[filename_img(i,:) '_phase.mat']) ); % load recover results
    height_i=height;
    clear height;
    
    im2 = im2double(imread( [ filename_img(i,:) '.jpg' ] )); % load input distorted images
    im2= im2(35:end,220:2370);
    
    if ~exist( 'height_save', 'var')
        height_save=height_i;
    else
        temp=height_save-height_i;
        temp=temp(~capture_area);
        height_i=height_i+mean(temp(:));
%         height_i(~capture_area)=0;
        height_save=height_i;
        clear temp;
    end
    
    height_i=(height_i.*255)./max_phase;
    % resize image for saving in gif format
    if max(size(height_i,1),size(height_i,2))>700
        temp=max(size(height_i,1),size(height_i,2))./700;
        temp=1./temp;
        height_i=imresize(height_i,temp,'bicubic');
        im2=imresize(im2,temp,'bicubic');
        clear temp;
    end
    
    path=fullfile('output','phase video');
    if ~exist( path, 'dir')
        mkdir(path);
    end
    
    ii=ii+1;
    if ii==1
        imwrite(height_i,jet(255), fullfile(path,'phase.gif') ,'DelayTime',delaytime,'LoopCount',Inf);
    else
        imwrite(height_i,jet(255), fullfile(path,'phase.gif') ,'WriteMode','append','DelayTime',delaytime);
    end
    
    if ii==1
        imwrite(im2uint8(im2), fullfile(path,'input distorted video.gif') ,'DelayTime',delaytime,'LoopCount',Inf);
    else
        imwrite(im2uint8(im2), fullfile(path,'input distorted video.gif') ,'WriteMode','append','DelayTime',delaytime);
    end
    
end
    
    
    
    
    
    
    