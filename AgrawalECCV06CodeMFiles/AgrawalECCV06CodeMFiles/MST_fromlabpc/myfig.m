function [] = myfig(im,a,b,flag);

PRINT_IMG = 0;

[H,W,C] = size(im);
if(C==3)
    im = uint8(im);
end

if(exist('a','var') & exist('b','var'))
    if(exist('flag','var'))
        figure;imagesc(im,[a b]);pixval;
        if(PRINT_IMG==0)
            colorbar;
        end
    else
        figure;imagesc(im,[a b]);pixval;colormap gray;
        if(PRINT_IMG==0)
            colorbar;
        end
    end
elseif(exist('a','var'))
    figure;imagesc(im);pixval;
    if(PRINT_IMG==0)
        colorbar;
    end
else
    figure;imagesc(im);pixval;colormap gray;
    if(PRINT_IMG==0)
        colorbar;
    end
end


