function warpI=warpFLColor1(im2,vx,vy)
if isfloat(im2)~=1
    im2=im2double(im2);
end
if exist('vy')~=1
    vy=vx(:,:,2);
    vx=vx(:,:,1);
end
nChannels=size(im2,3);
for i=1:nChannels
    [im,isNan]=warpFL(im2(:,:,i),vx,vy);
    warpI(:,:,i)=im;
end