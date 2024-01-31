function fakeplot(varargin)
fake=varargin{end};
x=fake.mag;
if nargin==2,  x=varargin{1}; end;
[c,b,s]=photerrors(x,fake);

HeadSep = 0.05;
FootSep = 0.1;
SpanSep = 0.02;
LeftSep = 0.1;

Height = (1-HeadSep-FootSep-SpanSep)/2;
Width = 0.85;

h1 = axes('Position',[LeftSep,FootSep+Height+SpanSep,Width,Height]);
plot(x,c,'-');
ylabel('Completeness');
set(h1,'FontName','times',...
    'YLim',[0,1],...
    'XAxisLocation','top');
text(0.97,0.95,fake.band,'Units','normalized','FontName','times','FontSize',15,'HorizontalAlignment','right','VerticalAlignment','top');

h2 = axes('Position',[LeftSep,FootSep,Width,Height]);
xyerrorbar(x,b,'yerr',s,'ycap',0,'-');
ylabel('Out-In');
xlabel('Input')
set(h2,'FontName','times',...
    'YDir','reverse',...
    'XAxisLocation','bottom', 'XLim',get(h1,'XLim') );
