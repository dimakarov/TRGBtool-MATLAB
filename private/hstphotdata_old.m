function data = hstphotdata(filename)
%Columns:
%  HSTphot with 27 columns output
c27.chi   =  4 ;
c27.sharp =  6 ;
c27.type  =  9 ;
c27.F606  = 12 ;
c27.Verr  = 14 ;
c27.F814  = 21 ;
c27.Ierr  = 23 ;
%  HSTphot with 23 columns output
c23.chi   =  4 ;
c23.sharp =  6 ;
c23.type  =  7 ;
c23.F606  = 10 ;
c23.Verr  = 12 ;
c23.F814  = 18 ;
c23.Ierr  = 20 ;

%Load file:
tab = load(filename);

switch size(tab,2)
    case 23,  c=c23;
    case {27,63},  c=c27;
    otherwise, error('Unknown version of HSTphot output.');
end;

tab( tab(:,c.F606)>98, c.F606 ) = NaN;
tab( tab(:,c.F814)>98, c.F814 ) = NaN;

a=tblselect( tab, c, 'type',1.5, 'sharp',0.5, 'chi',2.5, 'Ierr',0.3 );

%V passband
data(1).band = 'F606W';
data(1).mag  = a(:,c.F606);
data(1).err  = a(:,c.Verr);

%I passband
data(2).band = 'F814W';
data(2).mag  = a(:,c.F814);
data(2).err  = a(:,c.Ierr);
