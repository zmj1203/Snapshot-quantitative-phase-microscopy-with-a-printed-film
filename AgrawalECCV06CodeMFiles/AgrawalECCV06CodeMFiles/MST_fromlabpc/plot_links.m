function [] = plot_links(mask_gx,mask_gy)

[H,W] = size(mask_gx);

[x,y] = meshgrid(1:W,1:H);
figure;plot(x(:),y(:),'r*');hold on;
[x,y] = meshgrid(1:W-1,1:H);
line([x(:)';x(:)'+1],[y(:)';y(:)']);
[x,y] = meshgrid(1:W,1:H-1);
line([x(:)';x(:)'],[y(:)';y(:)'+1]);
clear x y

idx = find(mask_gx==1);
[y1,x1] = ind2sub([H W],idx);
hh = line([x1';x1'+1],[y1';y1']);
set(hh(:),'LineWidth',5);
plot(x1(:),y1(:),'bs');hold on;

idx = find(mask_gy==1);
[y1,x1] = ind2sub([H W],idx);
hh = line([x1';x1'],[y1';y1'+1]);
set(hh(:),'LineWidth',5);
plot(x1(:),y1(:),'bd');hold on;
clear idx y1 x1
axis ij
