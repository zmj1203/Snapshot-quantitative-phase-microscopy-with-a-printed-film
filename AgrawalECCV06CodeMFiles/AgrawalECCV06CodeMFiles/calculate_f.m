
% Calculate divergence of gradient field gx,gy 

function [f] = calculate_f(gx,gy,wx,wy)

[H,W] = size(gx);

gx(:,end) = 0;
gy(end,:) = 0;

if(exist('wx','var') & exist('wy','var'))
    gx = gx.*wx;
    gy = gy.*wy;
end

gx = padarray(gx,[1 1],0,'both');
gy = padarray(gy,[1 1],0,'both');

gxx = zeros(size(gx)); gyy = gxx; f = gxx;
j = 1:H+1;
k = 1:W+1;
% Laplacian
gyy(j+1,k) = gy(j+1,k) - gy(j,k);
gxx(j,k+1) = gx(j,k+1) - gx(j,k);
f = gxx + gyy;
f = f(2:end-1,2:end-1);

