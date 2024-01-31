function data = hstphotdata(filename)
%Load file:
tab = load(filename);

switch size(tab,2);

 case 23, 
    
  % Read HSTphot version 1.0 stars from the file
  %
  % HSTphot file columns:
  %   1 : chip
  %   2 : X
  %   3 : Y
  %   4 : chi
  %   5 : S_N
  %   6 : sharp
  %   7 : type
  %   8 : count_v
  %   9 : sky_v
  %  10 : magF606
  %  11 : V
  %  12 : error_v
  %  13 : chi_v
  %  14 : S_N_v
  %  15 : sharp_v
  %  16 : count_i
  %  17 : sky_i
  %  18 : magF814
  %  19 : I
  %  20 : error_i
  %  21 : chi_i
  %  22 : S_N_i
  %  23 : sharp_i

  c.chi    =   4;
  c.sharp  =   6;
  c.type   =   7;
  c.F606   =  10;
  c.Verr   =  12;
  c.F814   =  18;
  c.Ierr   =  20;
  
  tab( tab(:,c.F606)>98, c.F606 ) = NaN;
  tab( tab(:,c.F814)>98, c.F814 ) = NaN;

  a=tblselect( tab, c, 'type',1.5, 'sharp',0.5, 'chi',2.5, 'Ierr',0.3 );
  
 case 27,

  % Read HSTphot version 1.1.0 stars from the file
  %
  % HSTphot file columns:
  %   1 : chip
  %   2 : X
  %   3 : Y
  %   4 : chi
  %   5 : S_N
  %   6 : sharp
  %   7 : round
  %   8 : inum
  %   9 : type
  %  10 : count_v
  %  11 : sky_v
  %  12 : magF606
  %  13 : V
  %  14 : error_v
  %  15 : chi_v
  %  16 : S_N_v
  %  17 : sharp_v
  %  18 : round_v
  %  19 : count_i
  %  20 : sky_i
  %  21 : magF814
  %  22 : I
  %  23 : error_i
  %  24 : chi_i
  %  25 : S_N_i
  %  26 : sharp_i
  %  27 : round_i

  c.chi    =   4;
  c.sharp  =   6;
  c.type   =   9;
  c.F606   =  12;
  c.Verr   =  14;
  c.F814   =  21;
  c.Ierr   =  23;
  
  tab( tab(:,c.F606)>98, c.F606 ) = NaN;
  tab( tab(:,c.F814)>98, c.F814 ) = NaN;

  a=tblselect( tab, c, 'type',1.5, 'sharp',0.5, 'chi',2.5, 'Ierr',0.3 );
  
 case {29,149},

  % Read HSTphot version 1.1.2 stars from the file
  %
  % HSTphot file columns:
  %   1 : chip
  %   2 : X
  %   3 : Y
  %   4 : chi
  %   5 : S_N
  %   6 : sharp
  %   7 : round
  %   8 : inum
  %   9 : type
  %  10 : count_v
  %  11 : sky_v
  %  12 : magF606
  %  13 : V
  %  14 : error_v
  %  15 : chi_v
  %  16 : S_N_v
  %  17 : sharp_v
  %  18 : round_v
  %  19 : crowd_v
  %  20 : count_i
  %  21 : sky_i
  %  22 : magF814
  %  23 : I
  %  24 : error_i
  %  25 : chi_i
  %  26 : S_N_i
  %  27 : sharp_i
  %  28 : round_i
  %  29 : crowd_i

  c.chi    =   4;
  c.sharp  =   6;
  c.type   =   9;
  c.F606   =  12;
  c.Verr   =  14;
  c.F814   =  22;
  c.Ierr   =  24;
  
  tab( tab(:,c.F606)>98, c.F606 ) = NaN;
  tab( tab(:,c.F814)>98, c.F814 ) = NaN;

  a=tblselect( tab, c, 'type',1.5, 'sharp',0.5, 'chi',2.5, 'Ierr',0.3 );

 case {43,331}

  % Read DOLPHOT ACS stars from the file
  %
  % DOLPHOT ACS file columns:
  %   1 : extention
  %   2 : chip
  %   3 : X
  %   4 : Y
  %   5 : chi
  %   6 : S_N
  %   7 : sharp
  %   8 : round
  %   9 : maj_axis
  %  10 : crowd
  %  11 : type
  %  12 : count_v
  %  13 : background_v
  %  14 : magF606W
  %  15 : V
  %  16 : error_v
  %  17 : chi_v
  %  18 : S_N_v
  %  19 : sharp_v
  %  20 : round_v
  %  21 : crowd_v
  %  22 : FWHM_v
  %  23 : ellip_v
  %  24 : PSF_A_v
  %  25 : PSF_B_v
  %  26 : PSF_C_v
  %  27 : err_fl_v
  %  28 : count_i
  %  29 : background_i
  %  30 : magF814W
  %  31 : I
  %  32 : error_i
  %  33 : chi_i
  %  34 : S_N_i
  %  35 : sharp_i
  %  36 : round_i
  %  37 : crowd_i
  %  38 : FWHM_i
  %  39 : ellip_i
  %  40 : PSF_A_i
  %  41 : PSF_B_i
  %  42 : PSF_C_i
  %  43 : err_fl_i

  c.chi    =   5;
  c.sharp  =   7;
  c.type   =  11;
  c.F606   =  14;
  c.Verr   =  16;
  c.SNv    =  18;
  c.erflv  =  27;
  c.F814   =  30;
  c.Ierr   =  32;
  c.SNi    =  34;
  c.erfli  =  43;
  
  tab( tab(:,c.F606)>98, c.F606 ) = NaN;
  tab( tab(:,c.F814)>98, c.F814 ) = NaN;

%  p= ...
%    tab(:,c.chi)<=5   &...
%    tab(:,c.sharp).^2<=0.09   &...
%    tab(:,c.type)==1  &...
%    tab(:,c.SNi)>=5  &...
%    tab(:,c.erfli)==0  ;
  p= ...
    tab(:,c.type)<=2  &...
    tab(:,c.chi)<2.5   &...
    tab(:,c.sharp).^2<0.09   &...
    tab(:,c.SNi)>=5  &...
    tab(:,c.erfli)<8  ;
  a=tab(p,:);

 otherwise
  error('Cannot read the photometry data file');
end;

%V passband
data(1).band = 'F606W';
data(1).mag  = a(:,c.F606);
data(1).err  = a(:,c.Verr);

%I passband
data(2).band = 'F814W';
data(2).mag  = a(:,c.F814);
data(2).err  = a(:,c.Ierr);
