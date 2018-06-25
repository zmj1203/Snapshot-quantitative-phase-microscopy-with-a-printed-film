

% kernel should be symmteric
% Calculate weighted divergence (uD in paper)

function [f] = calculate_f_tensor(gx,gy,d11,d12,d21,d22)


[H,W] = size(gx);


gx(:,end) = 0;
gy(end,:) = 0;

if(~(exist('d11','var') & exist('d12','var') & exist('d21','var') & exist('d22','var')))
    disp('Weights are all zeros')
    d11 = ones(H,W);
    d21 = d11;
    d12 = d11;
    d22 = d11;
end

d21 = d12;


gx1 = gx.*d11;
gy1 = gy.*d22;
gx1 = padarray(gx1,[1 1],0,'both');
gy1 = padarray(gy1,[1 1],0,'both');
gxx = zeros(size(gx1)); gyy = gxx;
j = 1:H+1;
k = 1:W+1;
% Laplacian
gyy(j+1,k) = gy1(j+1,k) - gy1(j,k);
gxx(j,k+1) = gx1(j,k+1) - gx1(j,k);
f = gxx + gyy;
f = f(2:end-1,2:end-1);
clear gx1 gy1 gxx gyy


gx1 = gx.*d12;
gy1 = gy.*d21;

gx2 = gy.*d12;
gy2 = gx.*d21;

gx2(end,:) = gx1(end,:);
gy2(:,end) = gy1(:,end);


gx2(:,end) = 0;
gy2(end,:) = 0;


gx2 = padarray(gx2,[1 1],0,'both');
gy2 = padarray(gy2,[1 1],0,'both');
gxx = zeros(size(gx2)); gyy = gxx;
j = 1:H+1;
k = 1:W+1;
% Laplacian
gyy(j+1,k) = gy2(j+1,k) - gy2(j,k);
gxx(j,k+1) = gx2(j,k+1) - gx2(j,k);
f2 = gxx + gyy;
f2 = f2(2:end-1,2:end-1);

f = f + f2;



