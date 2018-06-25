function [] = plot_links1(mask_gx,mask_gy)

% mask_gx(1,:) = 0;
% mask_gx(end,:) = 0;
% mask_gx(:,end) = 0;
% mask_gy(:,1) = 0;
% mask_gy(:,end) = 0;
% mask_gy(end,:) = 0;





[H,W] = size(mask_gx);
[x,y] = meshgrid(1:W,1:H);
figure;
hh = plot(x(:),y(:),'r*');
hold on;
set(hh,'MarkerSize',10);


for i = 1:H
    for j = 1:W
        if(mask_gx(i,j)==0 & j<W)
            hh = line([j;j+1],[i;i]);
            set(hh(:),'LineWidth',2);
        end
        if(mask_gy(i,j)==0 & i<H)
            hh = line([j;j],[i;i+1]);
            set(hh(:),'LineWidth',2);
        end
    end
end
axis off;
axis ij;

