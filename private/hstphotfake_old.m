function fake = hstphotfake(filename)
%Columns:
c.stF606=  9 ;
c.stF814= 10 ;
c.chi   = 14 ;
c.sharp = 16 ;
c.type  = 19 ;
c.F606  = 22 ;
c.Verr  = 24 ;
c.F814  = 31 ;
c.Ierr  = 33 ;

%Load file:
tab = load(filename);
tab( tab(:,c.F606)>98, c.F606 ) = NaN;
tab( tab(:,c.F814)>98, c.F814 ) = NaN;

%V passband
a=tblselect( tab, c, 'type',1.5, 'sharp',0.5, 'chi',2.5, 'Verr',0.3, 'F606', 98 );
fake(1).band = 'F606';
[fake(1).mag,fake(1).completeness,fake(1).bias,fake(1).std] = ...
    GetSmoothedStat( tab(:,c.stF606), a(:,c.stF606), a(:,c.F606) );

%I passband
a=tblselect( tab, c, 'type',1.5, 'sharp',0.5, 'chi',2.5, 'Ierr',0.3, 'F814', 98 );
fake(2).band = 'F814';
[fake(2).mag,fake(2).completeness,fake(2).bias,fake(2).std] = ...
    GetSmoothedStat( tab(:,c.stF814), a(:,c.stF814), a(:,c.F814) );



function [xi,c,b,s] = GetSmoothedStat( Xall, X, Y )
%Get window parameter
w = median(abs(X-median(X))) / 0.6745 ;
w = w * (4/(3*length(X)))^(1/5);
w = max( w/4, 0.005 );
%Get interpolation points
xi = linspace(min(X),max(X),100);
xi = [xi,max(xi)+0.5*w,max(xi)+w];
xi = xi(:);
%Init variables
dX = Y-X;
nall = zeros(size(xi));
n = nall;
b = nall;
s = nall;
for k=1:length(xi)
    nall(k) = sum( exp(-0.5.*((xi(k)-Xall)./w).^2) ) ./ ( w .* sqrt(2*pi) );
    %Probability for each point
    p = exp(-0.5.*((xi(k)-X)./w).^2) ./ ( w .* sqrt(2*pi) );
    %Effective number
    n(k) = sum( p );
    %Weighted Mean
    b(k) = sum( dX.*p ) ./ n(k) ;
    %Weighted Std
    s(k) = sqrt( sum( dX.^2.*p ) ./ n(k) - b(k).^2 ) ;
    if n(k)>=2, s(k) = s(k).* sqrt(n(k)./(n(k)-1)) ; end;
end;
c = n./nall;
c([end-1,end])=0;
ind = ~isfinite(c) | ~isfinite(b) | ~isfinite(s) ;
c(ind)=[];
b(ind)=[];
s(ind)=[];
xi(ind)=[];
%Interpolation coefficients
pp = pchip(xi,c);
c  = pp.coefs;
pp = pchip(xi,b);
b  = pp.coefs;
pp = pchip(xi,s);
s  = pp.coefs;
xi = pp.breaks;
return;