
% r1 is the estimated shape (using MST)
% gx , gy are the given gradients
% sigma -> gaussian noise
% Add gradients which are within 3*sigma

function [Z_alpha,mask_gx_new,mask_gy_new] = iterative_add_gradients(Z_alpha,gx,gy,sigma,mask_gx_new,mask_gy_new,invalid_estimation)


[H,W] = size(Z_alpha);
nn = 50;
alpha = 3*sigma;


% weights for gradients
WM1 = abs(gx);
WM2 = abs(gy);
maxval = max(max(WM1(:)),max(WM2(:)));
idx = find(invalid_estimation==1);
WM1(idx) = maxval;
WM2(idx) = maxval;




for ii = 1:nn

    rr_prev = Z_alpha;
    clear rr

    [gx_alpha,gy_alpha] = calculate_gradients(Z_alpha,0,0);


    idx1 = find(abs(gx_alpha-gx) > (alpha+0.001) & mask_gx_new==0);
    disp(sprintf('Gradients which went out of alpha range in new estimation = %d',size(idx1,1)));
    n3 = size(idx1,1);
    clear idx1 n3

    idx2 = find(abs(gy_alpha-gy) > (alpha+0.001) & mask_gy_new==0);
    disp(sprintf('Gradients which went out of alpha range in new estimation = %d',size(idx2,1)));
    n4 = size(idx2,1);
    clear idx2 n4


    idx = find(abs(gx_alpha-gx) <= alpha & mask_gx_new==1);
    n1 = size(idx,1);
    disp(sprintf('Number of extra gradients which are within alpha = %d',size(idx,1)));
    mask_gx_new(idx) = 0;

    idx = find(abs(gy_alpha-gy) <= alpha & mask_gy_new==1);
    n2 = size(idx,1);
    disp(sprintf('Number of extra gradients which are within alpha = %d',size(idx,1)));
    mask_gy_new(idx) = 0;


    if((n1+n2)>0)
        idx = find(invalid_estimation==1);
        mask_gx_new(idx) = 1;
        mask_gy_new(idx) = 1;

        %[mask_gx_new,mask_gy_new] = mst_matlab(H,W,mask_gx_new,mask_gy_new,WM1,WM2);
        [mask_gx_new,mask_gy_new] = RunMSTCCode(H,W,mask_gx_new,mask_gy_new,WM1,WM2);
        disp(sprintf('Final Unknowns gx = %d, gy = %d',sum(mask_gx_new(:)),sum(mask_gy_new(:))));

        [gx1,gy1] = curlcorrection_2d_neumann(gx,gy,mask_gx_new,mask_gy_new);

        Z_alpha = poisson_solver_function_neumann(gx1,gy1);
        Z_alpha = Z_alpha - min(Z_alpha(:));
        clear gx1 gy1

        rr = Z_alpha;

        
    else
        disp('No new gradients found: Breaking;')
        break
    end


    %find % change
    ee = zeros(H,W);
    idx = find(abs(rr_prev) > 0);
    ee(idx) = (rr_prev(idx) - rr(idx))./rr_prev(idx);
    ee = ee.^2;
    if(~isempty(idx) & mean(ee(:)) < 1e-6)
        disp('***************Breaking******************')
        disp('Norm of relative change less than 1e-6');
        disp('***************Breaking******************')
        break;
    end
end
disp(sprintf('Iterations needed = %d',ii))



