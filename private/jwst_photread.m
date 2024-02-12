function data = photread( filename )

tab = importdata(filename,',',1);

c.F1    = find( strcmp(tab.colheaders, 'inst_vega_mag1') );
c.F1err = find( strcmp(tab.colheaders, 'mag1_err') );
c.F2    = find( strcmp(tab.colheaders, 'inst_vega_mag2') );
c.F2err = find( strcmp(tab.colheaders, 'mag2_err') );

color = tab.data(:,c.F1) - tab.data(:,c.F2) ;
p = color>=0.50 & color<=1.75 ;

data(1).band = 'F090W' ;
data(1).mag = tab.data(p,c.F1) ;
data(1).err = tab.data(p,c.F1err) ;

data(2).band = 'F150W' ;
data(2).mag = tab.data(p,c.F2) ;
data(2).err = tab.data(p,c.F2err) ;