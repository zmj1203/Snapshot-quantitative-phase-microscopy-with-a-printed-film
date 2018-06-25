function [gx,gy,gx_d,gy_d] = calculate_gradients(img,GRADIENTS_CALCULATION,USE_DIAG)

gx_d = [];
gy_d = [];

if(~exist('USE_DIAG','var'))
    USE_DIAG = 0;
end


% find gradients in ambient image
if(GRADIENTS_CALCULATION==0)
    [H,W] = size(img);

    gx = zeros(H,W);
    gy = zeros(H,W);
    if(USE_DIAG)
        j = 2:H-1;
        k = 2:W-1;
        gx(j,k) = img(j,k+1) - img(j,k);
        gy(j,k) = img(j+1,k) - img(j,k);
    else
        j = 1:H;
        k = 1:W-1;
        gx(j,k) = img(j,k+1) - img(j,k);
        j = 1:H-1;
        k = 1:W;
        gy(j,k) = img(j+1,k) - img(j,k);
    end
    
    if(USE_DIAG)
        gx_d = zeros(H,W);
        gy_d = zeros(H,W);
        gx_d(j,k) = img(j+1,k+1) - img(j,k);
        gy_d(j,k) = img(j-1,k+1) - img(j,k);    
    end
    
    
    
    clear j k 
elseif(GRADIENTS_CALCULATION==1)
    [gx,gy] = gradient(img);    
elseif(GRADIENTS_CALCULATION==2)
    gradop = firstOrderDerivative(6);
    gx = imfilter(img,gradop,'symmetric');    
    gy = imfilter(img,gradop','symmetric');    
elseif(GRADIENTS_CALCULATION==3)
    [gx,gy] = cubic_gradients(img);
elseif(GRADIENTS_CALCULATION==-1)
    % New gradient definition
    [H,W] = size(img);
    gx = zeros(H,W);
    gy = zeros(H,W);
    if(USE_DIAG)
        j = 2:H-1;
        k = 2:W-1;
    else
        j = 1:H-1;
        k = 1:W-1;
    end
    gx(j,k) = img(j+1,k+1) - img(j+1,k);
    gy(j,k) = img(j+1,k+1) - img(j,k+1);
    if(USE_DIAG)
        error('Calculate_GRadients: code not written');
    end
    clear j k
elseif(GRADIENTS_CALCULATION==-2)
    %backward differences
    [H,W] = size(img);
    gx = zeros(H,W);
    gy = zeros(H,W);
    j = 2:H;
    k = 2:W;
    gx(j,k) = img(j,k) - img(j,k-1);
    gy(j,k) = img(j,k) - img(j-1,k);
    clear j k 
    if(USE_DIAG)
        error('Calculate_GRadients: code not written');
    end
elseif(GRADIENTS_CALCULATION==4)
    [H,W] = size(img);
    
    img = padarray(img,[1 1],0,'post');
    
    
    gx = zeros(H,W);
    gy = zeros(H,W);
    if(USE_DIAG)
        error('Code not written');
    else
        j = 1:H;
        k = 1:W;
    end
    
    gx(j,k) = img(j,k+1) - img(j,k);
    gy(j,k) = img(j+1,k) - img(j,k);
    clear j k 
else
    error('Variable GRADIENTS_CALCULATION is not set');
end
