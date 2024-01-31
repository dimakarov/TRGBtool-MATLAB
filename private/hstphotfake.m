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

switch size(tab,2)

 case 33,

  % Read fake stars from the HSTphot vers. 1.0 file and calculate the completeness
  %
  % Fake file columns:
  % 1 : chip_f
  % 2 : X_f
  % 3 : Y_f
  % 4 : stU
  % 5 : stB
  % 6 : stV
  % 7 : stR
  % 8 : stI
  % 9 : stF606
  %10 : stF814
  %11 : chip
  %12 : X
  %13 : Y
  %14 : chi
  %15 : S_N
  %16 : sharp
  %17 : type
  %18 : count_v
  %19 : sky_v
  %20 : magF606
  %21 : V
  %22 : error_v
  %23 : chi_v
  %24 : S_N_v
  %25 : sharp_v
  %26 : count_i
  %27 : sky_i
  %28 : magF814
  %29 : I
  %30 : error_i
  %31 : chi_i
  %32 : S_N_i
  %33 : sharp_i

  c.stF606=  9 ;
  c.stF814= 10 ;
  c.chi   = 14 ;
  c.sharp = 16 ;
  c.type  = 17 ;
  c.F606  = 20 ;
  c.Verr  = 22 ;
  c.F814  = 28 ;
  c.Ierr  = 30 ;

  %V passband
  a=tblselect( tab, c, 'type',1.5, 'sharp',0.5, 'chi',2.5, 'Verr',0.3, 'F606', 98 );
  fake(1).band = 'F606W';
  [fake(1).mag,fake(1).completeness,fake(1).bias,fake(1).std] = ...
      GetSmoothedStat( tab(:,c.stF606), a(:,c.stF606), a(:,c.F606) );

  %I passband
  a=tblselect( tab, c, 'type',1.5, 'sharp',0.5, 'chi',2.5, 'Ierr',0.3, 'F814', 98 );
  fake(2).band = 'F814W';
  [fake(2).mag,fake(2).completeness,fake(2).bias,fake(2).std] = ...
      GetSmoothedStat( tab(:,c.stF814), a(:,c.stF814), a(:,c.F814) );

 case 37,

  % Read fake stars from the HSTphot vers. 1.1 file and calculate the completeness
  %
  % Fake file columns:
  % 1 : chip_f
  % 2 : X_f
  % 3 : Y_f
  % 4 : stU
  % 5 : stB
  % 6 : stV
  % 7 : stR
  % 8 : stI
  % 9 : stF606
  %10 : stF814
  %11 : chip
  %12 : X
  %13 : Y
  %14 : chi
  %15 : S_N
  %16 : sharp
  %17 : round
  %18 : inum
  %19 : type
  %20 : count_v
  %21 : sky_v
  %22 : magF606
  %23 : V
  %24 : error_v
  %25 : chi_v
  %26 : S_N_v
  %27 : sharp_v
  %28 : round_v
  %29 : count_i
  %30 : sky_i
  %31 : magF814
  %32 : I
  %33 : error_i
  %34 : chi_i
  %35 : S_N_i
  %36 : sharp_i
  %37 : round_i

  c.stF606=  9 ;
  c.stF814= 10 ;
  c.chi   = 14 ;
  c.sharp = 16 ;
  c.type  = 19 ;
  c.F606  = 22 ;
  c.Verr  = 24 ;
  c.F814  = 31 ;
  c.Ierr  = 33 ;

  %V passband
  a=tblselect( tab, c, 'type',1.5, 'sharp',0.5, 'chi',2.5, 'Verr',0.3, 'F606', 98 );
  fake(1).band = 'F606W';
  [fake(1).mag,fake(1).completeness,fake(1).bias,fake(1).std] = ...
      GetSmoothedStat( tab(:,c.stF606), a(:,c.stF606), a(:,c.F606) );

  %I passband
  a=tblselect( tab, c, 'type',1.5, 'sharp',0.5, 'chi',2.5, 'Ierr',0.3, 'F814', 98 );
  fake(2).band = 'F814W';
  [fake(2).mag,fake(2).completeness,fake(2).bias,fake(2).std] = ...
      GetSmoothedStat( tab(:,c.stF814), a(:,c.stF814), a(:,c.F814) );

 case {39,159},

  % Read fake stars from the HSTphot vers. 1.1.2 file and calculate the completeness
  %
  % Fake file columns:
  % 1 : chip_f
  % 2 : X_f
  % 3 : Y_f
  % 4 : stU
  % 5 : stB
  % 6 : stV
  % 7 : stR
  % 8 : stI
  % 9 : stF606
  %10 : stF814
  %11 : chip
  %12 : X
  %13 : Y
  %14 : chi
  %15 : S_N
  %16 : sharp
  %17 : round
  %18 : maj_ax
  %19 : type
  %20 : count_v
  %21 : sky_v
  %22 : magF606
  %23 : V
  %24 : error_v
  %25 : chi_v
  %26 : S_N_v
  %27 : sharp_v
  %28 : round_v
  %29 : crowd_v
  %30 : count_i
  %31 : sky_i
  %32 : magF814
  %33 : I
  %34 : error_i
  %35 : chi_i
  %36 : S_N_i
  %37 : sharp_i
  %38 : round_i
  %39 : crowd_i

  c.stF606=  9 ;
  c.stF814= 10 ;
  c.chi   = 14 ;
  c.sharp = 16 ;
  c.type  = 19 ;
  c.F606  = 22 ;
  c.Verr  = 24 ;
  c.F814  = 32 ;
  c.Ierr  = 34 ;

  %V passband
  a=tblselect( tab, c, 'type',1.5, 'sharp',0.5, 'chi',2.5, 'Verr',0.3, 'F606', 98 );
  fake(1).band = 'F606W';
  [fake(1).mag,fake(1).completeness,fake(1).bias,fake(1).std] = ...
      GetSmoothedStat( tab(:,c.stF606), a(:,c.stF606), a(:,c.F606) );

  %I passband
  a=tblselect( tab, c, 'type',1.5, 'sharp',0.5, 'chi',2.5, 'Ierr',0.3, 'F814', 98 );
  fake(2).band = 'F814W';
  [fake(2).mag,fake(2).completeness,fake(2).bias,fake(2).std] = ...
      GetSmoothedStat( tab(:,c.stF814), a(:,c.stF814), a(:,c.F814) );

 case {51,371}

  % Read fake stars from DOLPHOT ACS file and calculate the completeness
  %
  % Fake file columns:
  % 1 : extention_in
  % 2 : chip_in
  % 3 : X_in
  % 4 : Y_in
  % 5 : count_v_in
  % 6 : F606W_in
  % 7 : count_i_in
  % 8 : F814W_in
  % 9 : exten
  %10 : chip
  %11 : x
  %12 : y
  %13 : chi
  %14 : S_N
  %15 : sharp
  %16 : round
  %17 : maj_axis
  %18 : crowd
  %19 : type
  %20 : count_v
  %21 : background_v
  %22 : F606W
  %23 : V
  %24 : err_v
  %25 : chi_v
  %26 : S_N_v
  %27 : sharp_v
  %28 : round_v
  %29 : crowd_v
  %30 : FWHM_v
  %31 : ellip_v
  %32 : psf_a_v
  %33 : psf_b_v
  %34 : psf_c_v
  %35 : err_fl_v
  %36 : count_i
  %37 : background_i
  %38 : F814W
  %39 : I
  %40 : err_i
  %41 : chi_i
  %42 : S_N_i
  %43 : sharp_i
  %44 : round_i
  %45 : crowd_i
  %46 : FWHM_i
  %47 : ellip_i
  %48 : psf_a_i
  %49 : psf_b_i
  %50 : psf_c_i
  %51 : err_fl_i

  c.stF606=  6 ;
  c.stF814=  8 ;
  c.chi   = 13 ;
  c.sharp = 15 ;
  c.type  = 19 ;
  c.F606  = 22 ;
  c.Verr  = 24 ;
  c.SNv   = 26 ;
  c.erflv = 35 ;
  c.F814  = 38 ;
  c.Ierr  = 40 ;
  c.SNi   = 42 ;
  c.erfli = 51 ;
  
  %V passband
%  p = ...
%      tab(:,c.type)==1 & ...
%      tab(:,c.chi)<=5 & ...
%      tab(:,c.sharp).^2<=0.09 & ...
%      tab(:,c.SNv)>=5 & ...
%      tab(:,c.erflv)==0 ;
  p = ...
      tab(:,c.type)<=2 & ...
      tab(:,c.chi)<=2.5 & ...
      tab(:,c.sharp).^2<0.09 & ...
      tab(:,c.SNv)>=5 & ...
      tab(:,c.erflv)<8 ;
  a=tab(p,:);

  fake(1).band = 'F606W';
  [fake(1).mag,fake(1).completeness,fake(1).bias,fake(1).std] = ...
      GetSmoothedStat( tab(:,c.stF606), a(:,c.stF606), a(:,c.F606) );

  %I passband
%  p = ...
%      tab(:,c.type)==1 & ...
%      tab(:,c.chi)<=5 & ...
%      tab(:,c.sharp).^2<=0.09 & ...
%      tab(:,c.SNi)>=5 & ...
%      tab(:,c.erfli)==0 ;
  p = ...
      tab(:,c.type)<=2 & ...
      tab(:,c.chi)<=2.5 & ...
      tab(:,c.sharp).^2<0.09 & ...
      tab(:,c.SNi)>=5 & ...
      tab(:,c.erfli)<8 ;
  a=tab(p,:);
      
  fake(2).band = 'F814W';
  [fake(2).mag,fake(2).completeness,fake(2).bias,fake(2).std] = ...
      GetSmoothedStat( tab(:,c.stF814), a(:,c.stF814), a(:,c.F814) );

 otherwise
  error('Cannot read the fake file')
end;

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
