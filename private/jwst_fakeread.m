function fake = fakeread(filename)

tab = importdata(filename,' ',1);

c.type = find( strcmp(tab.colheaders, '30') );

c.stF1  = find( strcmp(tab.colheaders, '5') ); % F090W
c.F1    = find( strcmp(tab.colheaders, '35') );
c.F1err = find( strcmp(tab.colheaders, '37') );
c.SN1   = find( strcmp(tab.colheaders, '39') );
c.Sharp1= find( strcmp(tab.colheaders, '40') );
c.Crowd1= find( strcmp(tab.colheaders, '42') );
c.Flag1 = find( strcmp(tab.colheaders, '43') );

c.stF2  = find( strcmp(tab.colheaders, '13') ); % F150W
c.F2    = find( strcmp(tab.colheaders, '48') );
c.F2err = find( strcmp(tab.colheaders, '50') );
c.SN2   = find( strcmp(tab.colheaders, '52') );
c.Sharp2= find( strcmp(tab.colheaders, '53') );
c.Crowd2= find( strcmp(tab.colheaders, '55') );
c.Flag2 = find( strcmp(tab.colheaders, '56') );

p =   tab.data(:,c.type) <=2 ...
    & tab.data(:,c.Crowd1) < 0.5 ...
    & tab.data(:,c.Sharp1).^2 <=0.01 ...
    & tab.data(:,c.SN1) >= 5 ...
    & tab.data(:,c.Flag1) <= 2 ;
fake(1).band = 'F090W' ;
[fake(1).mag,fake(1).completeness,fake(1).bias,fake(1).std] = ...
      GetSmoothedStat( tab.data(:,c.stF1), tab.data(p,c.stF1), tab.data(p,c.F1) );

p =   tab.data(:,c.type) <=2 ...
    & tab.data(:,c.Crowd2) < 0.5 ...
    & tab.data(:,c.Sharp2).^2 <=0.01 ...
    & tab.data(:,c.SN2) >= 5 ...
    & tab.data(:,c.Flag2) <= 2 ;
fake(2).band = 'F150W' ;
[fake(2).mag,fake(2).completeness,fake(2).bias,fake(2).std] = ...
      GetSmoothedStat( tab.data(:,c.stF2), tab.data(p,c.stF2), tab.data(p,c.F2) );


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