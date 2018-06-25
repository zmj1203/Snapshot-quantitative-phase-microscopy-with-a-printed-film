

function [C] = calculate_curl(gx,gy);

[H,W] = size(gx);
C = zeros(H,W);
j = 1:H-1;
k = 1:W-1;
C(j,k) = gx(j+1,k) - gx(j,k) + gy(j,k) - gy(j,k+1);
C(:,end) = 0;
C(end,:) = 0;
