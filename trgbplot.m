function trgbplot(data,varargin)
%TRGBPLOT plots the TRGB reconstruction using TRGBTOOL result.
%
%  trgbtool(data) plots the graphics using the data structure.
%  trgbtool(file) plots the graphics using the data stored into file.
%  trgbtool(...,'galaxy','galaxy name') sets up the galaxy name for plot.
%  trgbtool(...,'cmd.width',width) sets up the width of the CMD in the plot
%  trgbtool(...,'cmd.colorlim',[lbnd,rbnd]) sets up the left (lbnd) and
%    right (rbnd) color bounds of the CMD
%  trgbtool(...,'cmd.maglim',[minmag,maxmag]) sets up the minimal (minmag)
%    and maxaimal (maxmag) magnitudes of the CMD
%  trgbtool(...,'fit.model','on') shows the "true" shape of the LF without
%    taking into account observational effects.
%  trgbtool(...,'fit.sobel','on') adds the sobel filter behaviour


if ~isstruct(data) && exist(data)==2,  data=load(data); data=data.data; end;
if isstruct(data) && ~isfield(data,'Result'),  error('Unknown type structure'); end;
if ~isstruct(data), error('Unsupported type'); end;

vars = {'galaxy', 'cmd.width', 'cmd.colorlim', 'cmd.maglim', 'fit.model','fit.sobel'};
defs = {'', [], [], [], 'off','off'};
[err,galaxy, cmd.width,cmd.colorlim,cmd.maglim, fit.model,fit.sobel] = ...
    getargs(vars,defs,varargin{:});
error(err);

if (length(data.Galaxy)>0 && strcmp(galaxy,'')), galaxy=upper(data.Galaxy); end;
PlotData(data,galaxy,cmd,fit);



function PlotData(data,galaxy,cmd,fit)
figure('PaperOrientation','landscape', 'PaperType','A4', 'PaperUnits','normalized','PaperPosition',[0.05,0.05,0.9,0.9]);

Tsep = 0.05;
Bsep = 0.1;
Lsep = 0.1;
Rsep = 0.05;
Hsep = 0.05;
Vsep = 0.1;
VSsep = 0.01;

%===CMD===
Width = 0.4;
if ~isempty(cmd.width),  Width = min(cmd.width,(1-Lsep-Rsep-Hsep)*2/3); end;
Height = (1-Tsep-Bsep);
axes('Position',[Lsep,Bsep,Width,Height]);

plot(data.X,data.Y,'.k','MarkerSize',3);
XLim=xlim;
hold on;
plot([XLim(1),data.Result.Color.TRGB-0.5,NaN,data.Result.Color.TRGB+0.5,XLim(2)],...
    data.Result.Param(1)*ones(1,5),'-r');
X=[min(data.RoI.X),max(data.RoI.Y)];
Y=data.Start(1)+data.RoI.LF;
Y(1)=max(Y(1),min(data.RoI.Y));
Y(2)=min(Y(2),max(data.RoI.Y));
plot([X(2),X(1),X(1),X(2)],[Y(1),Y(1),Y(2),Y(2)],'--b');
set(gca,'YDir','reverse');
xlabel(data.Xlabel,'FontName','times','FontSize',14);
ylabel(data.Ylabel,'FontName','times','FontSize',14);
if isempty(cmd.maglim), cmd.maglim=ylim; end;
if isempty(cmd.colorlim), cmd.colorlim=[-1,3]; end;
axis equal;
set(gca,'Xlim',cmd.colorlim,'YLim',cmd.maglim);
text(0.05,0.95,galaxy,'Unit','normalized',...
    'VerticalAlignment','top','HorizontalAlignment','left',...
    'FontName','times','FontSize',16);
X=xlim;
text(X(1),data.Result.Param(1),sprintf(' %5.2f',data.Result.Param(1)),...
    'FontName','times','FontSize',10,'Color','r','VerticalAlignment','bottom','HorizontalAlignment','left');

%===Statistics===
mag = data.data(data.Yid).fake.mag;
[compl,bias,sigma] = photerrors(mag,data.data(data.Yid).fake);

LFbounds = data.Start(1)+data.RoI.LF;
%===Completeness===
WidthC = 1-Lsep-Rsep-Hsep-Width;
HeightC = ((Height-Vsep)/2-VSsep)/2;
axes('Position',[Lsep+Width+Hsep,1-Tsep-HeightC,WidthC,HeightC]);
plot(mag,compl,'-k',... 
    [LFbounds(1),LFbounds(1)],[0,1],'--b', [LFbounds(2),LFbounds(2)],[0,1],'--b', ...
    [data.Result.Param(1),data.Result.Param(1)],[0,1],'-r');
set(gca,'XAxisLocation','top','YLim',[0,1],'XLim',cmd.maglim);
%Bias
axes('Position',[Lsep+Width+Hsep,1-Tsep-HeightC-VSsep-HeightC,WidthC,HeightC]);
xyerrorbar(mag,bias,'yerr',sigma,'ycap',0,'-k');
hold on;
set( gca, 'YDir','reverse','XLim',cmd.maglim,'YLim',[-1.5,0.5]);
plot([LFbounds(1),LFbounds(1)],ylim,'--b',[LFbounds(2),LFbounds(2)],ylim,'--b');
plot([data.Result.Param(1),data.Result.Param(1)],ylim,'-r');
xlabel(data.Ylabel,'FontName','times','FontSize',14);

%===Fitting===
HeightF = (Height-Vsep)/2;
axes('Position',[Lsep+Width+Hsep,Bsep,WidthC,HeightF]);
%histogram
Selected = data.Y>=min(data.RoI.Y) & data.Y<=max(data.RoI.Y) & ...
    (data.X>=min(data.RoI.X) | ~isfinite(data.X)) ;
X=linspace( roundn(min(data.RoI.Y),-1), roundn(max(data.RoI.Y),-1), 50) ;
Xstep = median(diff(X));
N=histc(data.Y(Selected),X);
stairs(X,N,'k');
hold on;
%
p = data.Selected ;
N=length(data.Y(p));
%fit
Xlf=linspace(min(data.Y(p)),max(data.Y(p)),100);
Ylf=lf('obs',data.Result.Param,Xlf,data.data(data.Yid).fake) * N * Xstep;
%model
if strcmpi(fit.model,'on')
    Ylf0 = lf('model',data.Result.Param,Xlf);
    Ti = diff(LFbounds);
    Ci = diff( fnval( fnint( mkpp(data.data(data.Yid).fake.mag,data.data(data.Yid).fake.completeness) ), LFbounds ) );
    plot(Xlf,Ylf0 * Ti/Ci * N * Xstep,'--c','LineWidth',2);
end;
plot(Xlf,Ylf,'-r','LineWidth',2);
%get axes limits
set(gca,'Yscale','log','XLim',[min(data.RoI.Y),max(data.RoI.Y)]);
X=xlim;
Y=ylim; 
Y(1)=max( Y(1), 10.^floor(log10(min(Ylf(Xlf>X(1)&Xlf<X(2))))) );
Y(2)=min( Y(2), 10.^ceil(log10(max(Ylf(Xlf>X(1)&Xlf<X(2))))) );
%sobel
if strcmpi(fit.sobel,'on')
    plot(data.LF.X,data.LF.dY/max(data.LF.dY)*Y(2)*0.8,':k','LineWidth',1.2);
end;
%set Y axis limit
set(gca,'YLim',Y);
%
plot([data.Result.Param(1),data.Result.Param(1)],ylim,'-r');
plot([LFbounds(1),LFbounds(1)],ylim,'--b',[LFbounds(2),LFbounds(2)],ylim,'--b');
xlabel(data.Ylabel,'FontName','times','FontSize',14);
