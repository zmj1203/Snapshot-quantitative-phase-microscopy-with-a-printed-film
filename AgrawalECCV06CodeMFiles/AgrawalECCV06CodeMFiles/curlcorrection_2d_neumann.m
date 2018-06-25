

% Curl correction for 2D with Neumann boundary conditions
% Author: Amit Agrawal, 2005
% Input:

%   mask_gx, mask_gy  -> Gradients (bad or unknown) whos value need to
%   be determined by making curl equal to zero
% gx and gy are input gradients

%Output:

% gx, gy. The output gradient field has zero curl


function [gx,gy,A_gxgy,curl_gxgy] = curlcorrection_2d_neumann(gx,gy,mask_gx,mask_gy)

disp('======================================')
disp('Curl correction in 2D: Neumann')


mask_gx(:,end) = 0;
mask_gy(end,:) = 0;

idx_gx = find(mask_gx==1);
idx_gy = find(mask_gy==1);
N1 = size(idx_gx,1);
N2 = size(idx_gy,1);
disp(sprintf('Unknowns: x gradients = %d\ty gradients = %d\tTotal = %d',N1,N2,N1+N2));

if((N1+N2)==0)
    return
end

[H,W] = size(gx);

% put zeros wherever gx and gy is unknown
gx = gx.*(1-mask_gx);
gy = gy.*(1-mask_gy);


N = H*W;
mask = logical(zeros(H,W));
mask(1:end-1,1:end-1,:) = 1;
idx = find(mask==1);
% % for gx
S1 = sparse(idx,idx,-1,N,2*N);
S2 = sparse(idx,idx+1,1,N,2*N);
% % for gy
S3 = sparse(idx,idx+N,1,N,2*N);
S4 = sparse(idx,idx+N+H,-1,N,2*N);
A = S1 + S2 + S3 + S4;
clear S1 S2 S3 S4 idx mask


[aa,bb] = ind2sub([H W],idx_gx);
% if gx is on first or last row only one loop else 2 loops
tt1 = idx_gx(find(aa==1));
tt2 = idx_gx(find(aa > 1 & aa < H));
tt3 = idx_gx(find(aa == H));
loops_gx = unique([tt1;tt2;tt2-1;tt3-1]);
clear tt1 tt2 tt3 aa bb

[aa,bb] = ind2sub([H W],idx_gy);
% if gy is on first or last col only one loop else 2 loops
tt1 = idx_gy(find(bb==1));
tt2 = idx_gy(find(bb > 1 & bb < W));
tt3 = idx_gy(find(bb == W));
loops_gy = unique([tt1;tt2;tt2-H;tt3-H]);
clear tt1 tt2 tt3 aa bb

loops = unique([loops_gx;loops_gy]);
clear loops_gx loops_gy


% find idx of gx corresponding to these loops
gx_idx = unique([loops;loops+1]);
% find idx of gy corresponding to these loops
gy_idx = unique([loops;loops+H]);


%find curl
A_prune = A(loops,:);
A_prune = A_prune(:,[gx_idx;N+gy_idx]);
x = [gx(gx_idx);gy(gy_idx)];
curl_gxgy = -A_prune*x;
clear x A_prune gx_idx gy_idx

% find A matrix corresponding to unknowns
A_gxgy = A(loops,:);
A_gxgy = A_gxgy(:,[idx_gx;N+idx_gy]);

nn_e = size(A_gxgy,1);
disp(sprintf('Total No. of equations in Ax=b: %d, Unknowns %d',nn_e,(N1+N2)));

if(nn_e < (N1+N2))
    disp('A is not full rank');
end

x = A_gxgy\curl_gxgy;

%put x
gx(idx_gx) = x(1:N1);
gy(idx_gy) = x(N1+1:end);

disp('======================================')




