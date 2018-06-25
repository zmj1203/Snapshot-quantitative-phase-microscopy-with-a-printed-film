
function [rr] = halfquadractic(p,q,Zgood)

global fac_outliers;
global maxZ;
global RMSE_TH;

disp('****************************************')
disp('Energy Minimization...')


[H,W] = size(p);

Z1 = poisson_solver_function_neumann(p,q);
Z1 = Z1 - min(Z1(:));
maxZ = max(Z1(:));


% current solution
disp('Taking LS as initial solution');
rr = Z1;


f = calculate_f(p,q);

MAG_TH = 0.1
PHI_FUNCTION = 2

if(PHI_FUNCTION==0)
    lamda = 2
elseif(PHI_FUNCTION==1)
    lamda = 10
else
    lamda = 10
end


niter = 10
for ii = 1:niter

    %half quadractic regularization
    disp('===================================')
    disp(sprintf('Iter = %d',ii))

    rr_prev = rr;

    %find auxillary variables based on phi. phi'(s)/s
    if(ii==1)
        gx_1 = p;
        gy_1 = q;
    else
        [gx_1,gy_1] = calculate_gradients(rr,0,0);
    end

    s = sqrt(gx_1.^2 + gy_1.^2);

    if(PHI_FUNCTION==0)
        bx = ones(H,W);
        by = ones(H,W);
    elseif(PHI_FUNCTION==1)
        bx = 1./((1+gx_1.^2));
        by = 1./((1+gy_1.^2));
    elseif(PHI_FUNCTION==2)
        bx = 1./(sqrt(1+gx_1.^2));
        by = 1./(sqrt(1+gy_1.^2));
    elseif(PHI_FUNCTION==3)
        bx = 1./((1+gx_1.^2).^2);
        by = 1./((1+gy_1.^2).^2);
    elseif(PHI_FUNCTION==4)
        bx = ones(H,W);
        by = ones(H,W);
        idx = find(abs(gx_1) > MAG_TH);
        bx(idx) = tanh(gx_1(idx))./gx_1(idx);
        idx = find(abs(gy_1) > MAG_TH);
        by(idx) = tanh(gy_1(idx))./gy_1(idx);
    elseif(PHI_FUNCTION==-1)
        [bx,by] = mst_matlab(H,W,ones(H,W),ones(H,W),abs(gx_1),abs(gy_1));
        lamda = 1
    end

    A = laplacian_matrix_neumann(H,W);
    A = A + lamda*laplacian_matrix_neumann(H,W,bx,by)/4;
    A = A(:,2:end);



    rr = -A\f(:);

    clear A
    rr = [0;rr];
    rr = reshape(rr,H,W);
    rr = rr - min(rr(:));
    if(fac_outliers~=[])
        fac_outliers
        rr = remove_outliers(rr,fac_outliers);
    end

    rr = maxZ*rr/max(rr(:));


    %find % change
    ee = zeros(H,W);
    idx = find(abs(rr_prev) > 0);
    ee(idx) = (rr_prev(idx) - rr(idx))./rr_prev(idx);
    ee = ee.^2;
    ee = mean(ee(:));
    if(ee < 1e-6 & ~isempty(idx))
        disp('Norm of relative change less than 1e-6');
        break;
    end

    if(exist('Zgood','var'))
        [mse_ls,rmse_ls] = calculate_mse(Zgood,rr,RMSE_TH);
        disp(sprintf('MSE = %f, Relative MSE = %f',mse_ls,rmse_ls));
    end

end

disp('Energy Method Done...')
disp('****************************************')

