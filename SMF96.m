function [F,dF,xi,S] = SMF96(mag,err,xi)
%SMF96 Sakai, Madore, Freeman, 1996, ApJ, 461, 713
%   [F,dF,Xi,S] = SMF96(MAG,ERR,Xi) Returns gauss smoothed luminosity
%   function F, edge-detection filter dF and mean error S at position xi
%   for magnitudes MAG, and photometric errors ERR.

mag=mag(:);
err=err(:);
p=~isfinite(mag);
mag(p) = [];
if length(err)>1,  err(p) = []; end;
if ~exist('xi')
    xi = linspace(min(mag),max(mag),100);
end;
xi=xi(:);

%Compute luminosity function and mean errors
E = err./2;  %redused error to compensate effect of oversmoothing
W=0.05;      %Half-size of smoothing window
F=zeros(size(xi));
S=F;
for k=1:length(xi)
    F(k) = sum( exp(-0.5.*((xi(k)-mag)./E).^2) ./ E ) ./ sqrt(2*pi) ;
    S(k) = mean( err( abs(mag-xi(k))<W ) );
end;

%Interpolate
pp = pchip(xi,F);
Fplus = ppval(pp,xi+S);
Fminus= ppval(pp,xi-S);
dF=Fplus-Fminus;