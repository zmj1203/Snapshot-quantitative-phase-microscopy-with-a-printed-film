

function [mask_gx_new,mask_gy_new] = RunMSTCCode(H,W,mask_gx,mask_gy,WM1,WM2)

% Find MST minimum spanning tree
fp = fopen('mask_gx.txt','wt');
fprintf(fp,'%d\n',W);
fprintf(fp,'%d\n',H);
fprintf(fp,'%d\n',mask_gx);
fclose(fp);

fp = fopen('mask_gy.txt','wt');
fprintf(fp,'%d\n',W);
fprintf(fp,'%d\n',H);
fprintf(fp,'%d\n',mask_gy);
fclose(fp);

fp = fopen('WM_1.txt','wt');
fprintf(fp,'%d\n',W);
fprintf(fp,'%d\n',H);
fprintf(fp,'%f\n',WM1);
fclose(fp);

fp = fopen('WM_2.txt','wt');
fprintf(fp,'%d\n',W);
fprintf(fp,'%d\n',H);
fprintf(fp,'%f\n',WM2);
fclose(fp);

% Run C code to connect the graph
!mst

fp = fopen('mask_gx_res.txt','rt');
[tt,count] = fscanf(fp,'%d',inf);
W = tt(1);
H = tt(2);
mask_gx_new = reshape(tt(3:end),H,W);
fclose(fp);

fp = fopen('mask_gy_res.txt','rt');
[tt,count] = fscanf(fp,'%d',inf);
W = tt(1);
H = tt(2);
mask_gy_new = reshape(tt(3:end),H,W);
fclose(fp);

