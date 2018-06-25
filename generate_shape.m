
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

function [r_ls,fc,r_M,rr,x,Z_alpha]=generate_shape(gx,gy,ifcom)

if nargin<=2
    ifcom=[0 1 0 0 0];
end

use_ls=ifcom(1);
use_fc=ifcom(2);
use_Mest=ifcom(3);
use_energy=ifcom(4);
use_AT=ifcom(5);

%==========================================================
if use_ls
%     disp('============================================');
%     disp('Algorithm I. Least squares solution by solving Poisson Equation')
    r_ls = poisson_solver_function_neumann(gx,gy);
    r_ls = r_ls - min(r_ls(:));
    disp('============================================');
else
    r_ls=zeros(size(gx));
end

%==========================================================
if use_fc
%     disp('============================================');
%     disp('Algorithm II. Frankot-Chellappa Algorithm')
    fc = frankotchellappa(gx,gy);
    disp('============================================');
else
    fc=zeros(size(gx));
end

%=====================================================
if use_Mest
%     disp('============================================');
%     disp('Algorithm IV. M estimator');
    r_M = M_estimator(gx,gy,0);
    r_M = r_M - min(r_M(:));
else
    r_M=zeros(size(gx));
end

%=====================================================
if use_energy
%     disp('============================================');
%     disp('Algorithm V. Regularization using energy minimization')
    rr = halfquadractic(gx,gy);
else
    rr=zeros(size(gx));
end

%=====================================================
if use_AT
%     disp('============================================');
%     disp(' Algorithm VI. Affine transformation of gradients using Diffusion tensor')
    x = AffineTransformation(gx,gy);
else
    x=zeros(size(gx));
end


