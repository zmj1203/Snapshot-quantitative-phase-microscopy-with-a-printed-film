

function [abs_mse,relative_mse] = calculate_mse(Z,Zest,th,mask_Z);

%th = threshold for relative mse

if(~exist('mask_Z','var'))
    mask_Z = ones(size(Z));
end

idx = find(mask_Z==1);

if(isempty(idx))
    disp('No pixels with valid Z');
    abs_mse = NaN;
    relative_mse = NaN;
    return
end


Z = Z(idx);
Zest = Zest(idx);
clear idx


ee = (Z-Zest).^2;
abs_mse = mean(ee(:));
clear ee


if(~exist('th','var'))
    th = 0.01
end

if(th < 0.01)
    th = 0.01
end

idx = find(abs(Z) > th);
if(~isempty(idx))
    ee = (Z(idx)-Zest(idx))./Z(idx);
    ee = ee.^2;
    relative_mse = mean(ee(:));
else
    relative_mse = NaN;
end



