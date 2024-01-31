function [xm,fm] = sfpmax(x,f)
%SFPMAX Sobel Filter Positive Maximums
%   XM=SFPMAX(X,F) Returns maxumums of Sobel filter applied to function F
%   at points X.

x=x(:);
f=[f(1);f(:);f(end)];
s = filter2([-1;0;1],f);  s([1,end])=[];
d = sign(diff(s)); d=[d(1);d];
ind = find( [diff(d);1]<0 & d>0 );
xm = x(ind);
fm = f(ind);
