
function [r1] = M_estimator(gx,gy,flag)

disp('=======================================')
disp('Using M estimation');


[H,W] = size(gx);

% 1 for Huber
% 2 for fair
USE_FUNCTION = 1;


if(~exist('flag','var'))
    flag = 0;
end

if(flag)
    disp('Initial solution LS');
    r1 = poisson_solver_function_neumann(gx,gy);
    r1 = r1 - min(r1(:));
else
    disp('Initial solution all zeros')
    r1 = zeros(H,W);
end


for ii = 1:50
    disp(sprintf('M estimation: Iteration = %d',ii))
    [gx1,gy1] = calculate_gradients(r1,0,0);

    if(USE_FUNCTION==1)
        disp('Using Huber')
        k = 1.345;
        c = 1.2107;
        xx = abs(gx1-gx);
        w_gx = zeros(H,W);
        idx = find(xx <= k);
        w_gx(idx) = 1;
        idx = find(xx >= k);
        w_gx(idx) = k./xx(idx);

        xx = abs(gy1-gy);
        w_gy = zeros(H,W);
        idx = find(xx <= k);
        w_gy(idx) = 1;
        idx = find(xx >= k);
        w_gy(idx) = k./xx(idx);
        clear xx idx
    elseif(USE_FUNCTION==2)
        disp('Using Fair')
        c = 1.3998;
        w_gx = 1./(1+((abs(gx1-gx))/c));
        w_gy = 1./(1+((abs(gy1-gy))/c));
    end


    idx = find(w_gx < 0 | w_gx < 0);
    if(~isempty(idx))
        error('Non negative weights in M estimation');
    end
    clear idx


    f = calculate_f_tensor(gx,gy,w_gx,zeros(H,W),zeros(H,W),w_gy);
    A = laplacian_matrix_tensor(H,W,w_gx,zeros(H,W),zeros(H,W),w_gy);


    x = -A(:,2:end)\f(:);
    clear A f
    x = [0;x];
    x = reshape(x,H,W);
    x = x - min(x(:));

    %mydisplay(x);title(sprintf('At iter = %d',ii));


    idx = find(abs(r1)>0.01);
    if(~isempty(idx))
        ee = (r1(idx) - x(idx))./r1(idx);
        ee = ee.^2;
        ee = mean(ee(:));
        if(ee < 1e-6)
            disp('Change in solution is less than 1e-6, Breaking');
            break;
        end
    end


    r1 = x;
    clear x
end

disp('=======================================')