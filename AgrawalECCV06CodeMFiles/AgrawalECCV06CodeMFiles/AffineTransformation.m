
function [Z,D11,D12,D22] = diffusion_kernel_function(gx,gy,im);

% Tensor based
% Instead of individual weights to gx and gy, we have a 2*2 tensor getting
% multiplied by [gx,gy] vector at each pixel
% get tensor values using local analysis

disp('****************************************')
disp('Diffusion Tensor')

global RMSE_TH;

[H,W] = size(gx);

disp('=======================================')

p = gx;
q = gy;


sigma = 0.5
ss = floor(6*sigma);
if(ss<3)
    ss = 3;
end
ww = fspecial('gaussian',ss,sigma)


T11 = filter2(ww,p.^2,'same');
T22 = filter2(ww,q.^2,'same');
T12 = filter2(ww,p.*q,'same');

% find eignen values
ImagPart = sqrt((T11 - T22).^2 + 4*(T12.^2));
EigD_1 = (T22 + T11 + ImagPart)/2.0;
EigD_2 = (T22 + T11 - ImagPart)/2.0;

clear L1 L2 alpha th THRESHOLD_SMALL

alpha = 0.02
THRESHOLD_SMALL = 1*max(EigD_1(:))/100
%THRESHOLD_SMALL = 0

L1 = ones(H,W);
idx = find(EigD_1 > THRESHOLD_SMALL);
L1(idx) = alpha + 1 - exp(-3.315./(EigD_1(idx).^4));
L2 = ones(H,W);


disp('getting tensor weights');
D11 = zeros(H,W);
D12 = zeros(H,W);
D22 = zeros(H,W);

tic
for ii = 1:H
    for jj = 1:W
        Wmat = [T11(ii,jj) T12(ii,jj);T12(ii,jj) T22(ii,jj)];
        [v,d] = eig(Wmat);
        if(d(1,1)>d(2,2))
            disp('swapping !!!')
            d1 = d;
            d1(1,1) = d(2,2);
            d1(2,2) = d(1,1);
            d = d1;clear d1;
            v1 = v;
            v1(:,1) = v(:,2);
            v1(:,2) = v(:,1);
            v = v1;clear v1;
        end

        % d(1,1) is smaller
        d(1,1) = L2(ii,jj);
        d(2,2) = L1(ii,jj);

        Wmat = v*d*v';
        D11(ii,jj) = Wmat(1,1);
        D22(ii,jj) = Wmat(2,2);
        D12(ii,jj) = Wmat(1,2);
    end
end
ttime = toc;
disp(sprintf('Done.. Time = %f',ttime));

%     myfig(L1);title('L1')
%     myfig(L2);title('L2')
%     myfig(D11);title('D11')
%     myfig(D12);title('D12')
%     myfig(D22);title('D22')
%     keyboard


A = laplacian_matrix_tensor(H,W,D11,D12,D12,D22);
f = calculate_f_tensor(p,q,D11,D12,D12,D22);

A = A(:,2:end);
f = f(:);


tic
Z = A\f;
ttime = toc;
disp(sprintf('Time for solving Ax=b = %f',ttime));

Z = [0;-Z];
Z = reshape(Z,H,W);
Z = Z - min(Z(:));


if(exist('im','var'))
    [abs_mse,relative_mse] = calculate_mse(im,Z,RMSE_TH);
    abs_mse_all(run_iter,1) = abs_mse;
    disp(sprintf('MSE: %f , %f',abs_mse,relative_mse));
end


disp('Diffusion Tensor Done...')
disp('****************************************')







