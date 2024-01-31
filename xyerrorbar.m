function h=xyerrorbar(x,y,varargin) ;

hold_state = ishold;

xl = NaN;
xu = NaN;
yl = NaN;
yu = NaN;
xcap=0;
ycap=0;
symbol = '.';
esymbol= '-';

L=1;
while L<=length(varargin)
    switch varargin{L}
    case 'xerr'
        L=L+1;
        if L<=length(varargin) & ~isstr(varargin{L})
            xl = varargin{L};
            xu = xl ;
            L=L+1;
            if L<=length(varargin) & ~isstr(varargin{L})
                xu = varargin{L};
                L=L+1;
            end;
        end;
    case 'yerr'
        L=L+1;
        if L<=length(varargin) & ~isstr(varargin{L})
            yl = varargin{L};
            yu = yl ;
            L=L+1;
            if L<=length(varargin) & ~isstr(varargin{L})
                yu = varargin{L};
                L=L+1;
            end;
        end;
    case 'xcap'
        L=L+1;
        if L<=length(varargin) & ~isstr(varargin{L})
            xcap = varargin{L};
            L=L+1;
        end;
    case 'ycap'
        L=L+1;
        if L<=length(varargin) & ~isstr(varargin{L})
            ycap = varargin{L};
            L=L+1;
        end;
    otherwise
        [Lin,Col,Mark] = colstyle(varargin{L});
        symbol = [Lin Mark Col] ;
        esymbol= ['-' Col] ;
        L=L+1;
    end;
end;

xtee = (max(x(:))-min(x(:))) * xcap/2 ;
ytee = (max(y(:))-min(y(:))) * ycap/2 ;

Xleft = x-xl ;
Xright= x+xu ;
Ybot = y-yl ;
Ytop = y+yu ;
xlcap = x-ytee;
xrcap = x+ytee;
ybcap = y-xtee;
ytcap = y+xtee;

n=length(x);

Xb = zeros(18*n,1) ;
Xb(1:18:end,:) = x(:);  % Vertical line
Xb(2:18:end,:) = x(:);
Xb(3:18:end,:) = NaN;
Xb(4:18:end,:) = xlcap(:);  % Top cap
Xb(5:18:end,:) = xrcap(:);
Xb(6:18:end,:) = NaN;
Xb(7:18:end,:) = xlcap(:);  % Bottom cap
Xb(8:18:end,:) = xrcap(:);
Xb(9:18:end,:) = NaN;
Xb(10:18:end,:) = Xleft(:);  % Horizontal line
Xb(11:18:end,:) = Xright(:);
Xb(12:18:end,:) = NaN;
Xb(13:18:end,:) = Xleft(:);  % Left cap
Xb(14:18:end,:) = Xleft(:);
Xb(15:18:end,:) = NaN;
Xb(16:18:end,:) = Xright(:);  % Right cap
Xb(17:18:end,:) = Xright(:);
Xb(18:18:end,:) = NaN;

Yb = zeros(18*n,1) ;
Yb(1:18:end,:) = Ybot(:);  % Vertical line
Yb(2:18:end,:) = Ytop(:);
Yb(3:18:end,:) = NaN;
Yb(4:18:end,:) = Ytop(:);  % Top cap
Yb(5:18:end,:) = Ytop(:);
Yb(6:18:end,:) = NaN;
Yb(7:18:end,:) = Ybot(:);  % Bottom cap
Yb(8:18:end,:) = Ybot(:);
Yb(9:18:end,:) = NaN;
Yb(10:18:end,:) = y(:);  % Horizontal line
Yb(11:18:end,:) = y(:);
Yb(12:18:end,:) = NaN;
Yb(13:18:end,:) = ybcap(:);  % Left cap
Yb(14:18:end,:) = ytcap(:);
Yb(15:18:end,:) = NaN;
Yb(16:18:end,:) = ybcap(:);  % Right cap
Yb(17:18:end,:) = ytcap(:);
Yb(18:18:end,:) = NaN;

h=plot(Xb,Yb,esymbol);
hold on
h=[h;plot(x,y,symbol)];

if ~hold_state, hold off; end;
