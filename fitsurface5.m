function z=fitsurface5(para,x)

z=para(1).*x(1,:).^2+para(2).*x(2,:).^2+para(3).*x(1,:).*x(2,:)+para(4).*x(1,:)+para(5).*x(2,:)+para(6);