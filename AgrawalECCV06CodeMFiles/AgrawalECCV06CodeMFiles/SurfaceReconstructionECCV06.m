
%=========================================================
% Matlab code for ECCV 2006 paper
% Copyright: Amit Agrawal, 2006
% http://www.umiacs.umd.edu/~aagrawal/
% Permitted for personal use and research purpose only
% Refer to the following citations:

%   1.  A. Agrawal, R. Raskar and R. Chellappa, "What is the Range of
%   Surface Reconstructions from a Gradient Field? European Conference on
%   Computer Vision (ECCV) 2006

%   2.  A. Agrawal, R. Chellappa and R. Raskar, "An Algebraic approach to surface reconstructions from gradient fields?
%   Intenational Conference on Computer Vision (ICCV) 2006
%=========================================================

clear all;close all;clc;

USE_ALGORITH_3 = 1;

global RMSE_TH;
global maxZ;


ADD_OUTLIERS = 1
ADD_NOISE = 1
RMSE_TH = 0.01


% generate synthetic surface (im)
synthetic_ramppeaks

maxZ = max(im(:));
[H,W] = size(im)
[ogx,ogy] = calculate_gradients(im,0,0);


% add noise in gradients
if(ADD_NOISE)
    tt = sqrt(ogx.^2 + ogy.^2);
    sigma = 5*max(tt(:))/100
    clear tt
else
    sigma = 0
end

gx = ogx + sigma*randn(H,W);
gy = ogy + sigma*randn(H,W);

%add uniformly distributed outliers in gradients
if(ADD_OUTLIERS)
    fac = 3
    outlier_x = rand(H,W) > 0.90;
    outlier_x(:,end) = 0;
    
    gx = gx + fac*outlier_x.*(2*(rand(H,W)>0.5)-1);
    
    outlier_y = rand(H,W) > 0.90;
    outlier_y(end,:) = 0;
    
    gy = gy + fac*outlier_y.*(2*(rand(H,W)>0.5)-1);
    outlier_x = double(outlier_x);
    outlier_y = double(outlier_y);
    disp(sprintf('Gx outliers = %d',sum(outlier_x(:))));
    disp(sprintf('Gy outliers = %d',sum(outlier_y(:))));
end
gx(:,end) = 0;
gy(end,:) = 0;




%==========================================================
disp('============================================');
disp('Algorithm I. Least squares solution by solving Poisson Equation')
r_ls = poisson_solver_function_neumann(gx,gy);
r_ls = r_ls - min(r_ls(:));


%==========================================================
disp('============================================');
disp('Algorithm II. Frankot-Chellappa Algorithm')
% FC
fc = frankotchellappa(gx,gy);
[mse_ls,rmse_ls] = calculate_mse(im,fc,RMSE_TH);
disp(sprintf('FC: MSE = %f, Relative MSE = %f',mse_ls,rmse_ls));


if(USE_ALGORITH_3)
    %===================================
    disp('============================================');
    disp('Algorithm III. Alpha-Surface')
    
    % assign weights to edges
    gmag = sqrt(gx.^2 + gy.^2);
    WM1 = abs(gx);  %gmag;
    WM2 = abs(gy);  %gmag;
    
    % Find MST minimum spanning tree
    mask_gx = ones(H,W);
    mask_gy = ones(H,W);
    [mask_gx_new,mask_gy_new] = RunMSTCCode(H,W,mask_gx,mask_gy,WM1,WM2);
    
    % Integrate using the gradients corresponding to the edges in the spanning
    % tree
    [gx1,gy1] = curlcorrection_2d_neumann(gx,gy,mask_gx_new,mask_gy_new);
    Z_alpha_init = poisson_solver_function_neumann(gx1,gy1);
    Z_alpha_init = Z_alpha_init - min(Z_alpha_init(:));
    clear gx1 gy1
    
    
    % Iteratively add gradients using tolerance alpha
    C = calculate_curl(gx,gy);
    sigma_new = sqrt(var(abs(C(:)))/4)
    invalid_estimation = zeros(H,W);
    [Z_alpha,mask_final_gx,mask_final_gy] = iterative_add_gradients(Z_alpha_init,gx,gy,sigma_new,mask_gx_new,mask_gy_new,invalid_estimation);
    Z_alpha = Z_alpha - min(Z_alpha(:));
    
end


%=====================================================
disp('============================================');
disp('Algorithm IV. M estimator');
r_M = M_estimator(gx,gy,0);
r_M = r_M - min(r_M(:));



%=====================================================
disp('============================================');
disp('Algorithm V. Regularization using energy minimization')
rr = halfquadractic(gx,gy,im);



%=====================================================
disp('============================================');
disp(' Algorithm VI. Affine transformation of gradients using Diffusion tensor')
[x,D11,D12,D22] = AffineTransformation(gx,gy);



close all;


mydisplay(im);
title('original');axis on;


mydisplay(r_ls);
axis on;title('Least Squares');

mydisplay(fc);
axis on;title('Frankot Chellappa');

if(USE_ALGORITH_3)
    mydisplay(Z_alpha_init);
    axis on;title('Initial spanning tree');
    
    mydisplay(Z_alpha);
    axis on;title('Alpha Surface');
end


mydisplay(r_M);
axis on;title('M estimator');

mydisplay(rr);
axis on;title('Energy Minimization');

mydisplay(x);
axis on;title('Affine Transformation');




[mse_ls,rmse_ls] = calculate_mse(im,r_ls,RMSE_TH);
disp(sprintf('LS: MSE = %f, Relative MSE = %f',mse_ls,rmse_ls));

[mse_ls,rmse_ls] = calculate_mse(im,fc,RMSE_TH);
disp(sprintf('FC: MSE = %f, Relative MSE = %f',mse_ls,rmse_ls));

[mse_ls,rmse_ls] = calculate_mse(im,r_M,RMSE_TH);
disp(sprintf('M estimator: MSE = %f, Relative MSE = %f',mse_ls,rmse_ls));

if(USE_ALGORITH_3)
    [mse_ls,rmse_ls] = calculate_mse(im,Z_alpha_init,RMSE_TH);
    disp(sprintf('MST: MSE = %f, Relative MSE = %f',mse_ls,rmse_ls));
    
    [mse_ls,rmse_ls] = calculate_mse(im,Z_alpha,RMSE_TH);
    disp(sprintf('MST final: MSE = %f, Relative MSE = %f',mse_ls,rmse_ls));
end


[mse_ls,rmse_ls] = calculate_mse(im,rr,RMSE_TH);
disp(sprintf('Energy: MSE = %f, Relative MSE = %f',mse_ls,rmse_ls));

[mse_ls,rmse_ls] = calculate_mse(im,x,RMSE_TH);
disp(sprintf('Affine Transformation: MSE = %f, Relative MSE = %f',mse_ls,rmse_ls));

diary off;



