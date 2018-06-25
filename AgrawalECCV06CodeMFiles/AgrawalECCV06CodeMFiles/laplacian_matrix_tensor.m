
% Laplacian matrix for D*[Zx;Zy] where D is 2*2 diffusion tensor
% kernel D should be symmteric


function [A] = laplacian_matrix_tensor(H,W,D11,D12,D21,D22)


if(exist('D11','var') & exist('D12','var') & exist('D21','var') & exist('D22','var'))
    disp('Weighted Poisson Solver');
else
    D11 = ones(H,W);
    D12 = ones(H,W);
    D21 = ones(H,W);
    D22 = ones(H,W);
    disp('All weights are one in diffusion tensor');
end


D21 = D12;


D11 = padarray(D11,[1 1],0,'both');
D12 = padarray(D12,[1 1],0,'both');
D21 = padarray(D21,[1 1],0,'both');
D22 = padarray(D22,[1 1],0,'both');


N = (H+2)*(W+2);
mask = zeros(H+2,W+2);
mask(2:end-1,2:end-1) = 1;
idx = find(mask==1);

A = sparse(idx,idx+1,-D22(idx),N,N);
A = A + sparse(idx,idx+H+2,-D11(idx),N,N);
A = A + sparse(idx,idx-1,-D22(idx-1),N,N);
A = A + sparse(idx,idx-H-2,-D11(idx-H-2),N,N);

A = A + sparse(idx,idx+1,-D12(idx),N,N);
A = A + sparse(idx,idx-H-2,-D12(idx-H-2),N,N);
A = A + sparse(idx,idx-H-2+1,D12(idx-H-2),N,N);
A = A + sparse(idx,idx+H+2,-D21(idx),N,N);
A = A + sparse(idx,idx-1,-D21(idx-1),N,N);
A = A + sparse(idx,idx-1+H+2,D21(idx-1),N,N);


A = A(idx,idx);
N = size(A,1);
dd = sum(A,2);
idx = [1:N]';
A = A + sparse(idx,idx,-dd,N,N);












