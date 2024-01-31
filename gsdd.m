function [F,dF,xi,u]=gsdd(x,varargin)
%GSDD Compute density and density derivative estimates using a gauss
%smoothing method
%
%   [F,dF,Xi]=GSDD(X) Computes a probability density and first
%   derivative estimates of sample in vector X. F is the vector of density
%   values and dF is the first derivative evaluated at the points in Xi.
%   The estimate is based on a normal kernel function, using a window
%   parameter that is a function of the number of points X. The density and
%   derivative is evaluated at 100 equally-spaced points covering the range
%   of the data in X.
%
%   [F,dF,Xi,U] = GSDD(...) also returns the width of the kernel
%   smoothing window. 

[F,xi,u] = ksdensity(x,varargin{:});
dF = filter2([-1;0;1],F(:)) ;
dF(1) = F(2)-F(1);
dF(end) = F(end)-F(end-1);
dX = diff(xi(:));
dX = [xi(2)-xi(1); dX(1:end-1)+dX(2:end); xi(end)-xi(end-1)];
dF = dF./dX;
dF=reshape(dF,size(xi));