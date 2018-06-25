
function [A] = laplacian_matrix_neumann(H,W,wgx,wgy)

if(~exist('wgx','var'))
    wgx = ones(H,W);
    wgy = ones(H,W);
    disp('Normal Poisson Solver');
else
    disp('Weighted Poisson Solver');
end

wgx = padarray(wgx,[1 1],0,'both');
wgy = padarray(wgy,[1 1],0,'both');

N = (H+2)*(W+2);
mask = zeros(H+2,W+2);
mask(2:end-1,2:end-1) = 1;
idx = find(mask==1);

A = sparse(idx,idx+1,-wgy(idx),N,N);
A = A + sparse(idx,idx+H+2,-wgx(idx),N,N);
A = A + sparse(idx,idx-1,-wgy(idx-1),N,N);
A = A + sparse(idx,idx-H-2,-wgx(idx-H-2),N,N);
A = A(idx,idx);
N = size(A,1);
dd = sum(A,2);
idx = [1:N]';
A = A + sparse(idx,idx,-dd,N,N);


  
