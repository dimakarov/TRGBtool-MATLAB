function Y = lf(action,varargin)
%LF Computes Luminosity Function
%    Y=LF(X,MAG,FAKE) Returns maximum likelihood function for model which
%    descibed by X, and photometry MAG and errors in FAKE structure.
%
%    Y=LF('ML',X,MAG,FAKE) is the same as previous.
%
%    Y=LF('MODEL',X,MAG) Returns model values of luminosity function for
%    given magnitudes MAG.
%
%    Y=LF('OBS',X,MAG,FAKE) Returns smoothed model luminosity function with
%    observational errors.
%
%    Y=LF('RND',X,N,FAKE) Returns magnitudes of stars which random
%    distributed with given parameters X of model and error FAKE.

if isnumeric(action)
    Y = ML(action,varargin{:});
    return;
end;
    
switch lower(action)
    case 'ml'
        Y = ML(varargin{:});
    case 'model'
        Y = LFmodel(varargin{:});
        Y = Y ./ LFmodeltot(varargin{:});
    case 'obs'
        [Y,Tot] = LFobs(varargin{:});
        Y = Y ./ Tot;
    case 'rnd'
        Y = LFrnd(varargin{:});
end;


function y = ML(X,mag,fake)
[f,fint] = LFobs(X,mag,fake);
y = length(mag).*log( fint ) - sum( log(f) ) ;


%---------------------------------
% Model of RGB Luminosity Function
function f=LFmodel(X,mag);
%X(1) - m_trgb
%X(2) - RGB slope
%X(3) - TRGB jump
%X(4) - AGB slope
dm=mag-X(1);
%RGB
p=dm>=0;
f(p) = 10.^(X(2).*dm(p)+X(3));
%AGB
p=dm<0;
f(p) = 10.^(X(4).*dm(p));


function f=LFmodeltot(X,mag)
A=min(mag)-X(1);
B=max(mag)-X(1);
F1 = (1-10.^(A*X(4))) ./ (X(4).*log(10));
F2 = (10.^(B*X(2))-1) .* 10.^X(3) ./ (X(2).*log(10));
f = F1+F2;


%---------------------------------
% LFobs(mhut) = int_{-inf}^{+inf}...
%  ( LF(X,m)*completeness(m)*normpdf(mhut,m+bias,sigma)*dm )
% LFint = int_{-inf}^{+inf} ( LF(X,m)*completeness(m)*
%  (normcdf(B,m+bias,sigma)-normcdf(B,m+bias,sigma))*dm ) 
function [f,fint] = LFobs(X,mag,fake)
[m0,a,b] = GetGrid(X,mag,fake);
if length(m0)>=length(mag),  m0 = mag;  end;
[f,fint] = LFquadg24(a,b,X,m0,fake);
if length(mag) > length(m0),  f = pchip(m0,f,mag); end;


function [m0,a,b] = GetGrid(X,mag,fake)
[compl,bias,sigma]=photerrors(X(1),fake);
a=min(mag);
b=max(mag);
c=X(1)+bias-1.5*sigma;
c=max(c,a);
d=X(1)+bias+1.5*sigma;
d=min(d,b);
m0 = linspace(a,c,ceil((c-a)/0.05)+1);
m0 = [ m0(1:end-1), linspace(c,d,ceil((d-c)/0.005)+1) ];
m0 = [ m0(1:end-1), linspace(d,b,ceil((b-d)/0.05)+1) ];




function [f,fint] = LFquadg24(A,B,X,mag,fake)
[m,w] = XWg24(X(1)-2,X(1)+2,50);
[compl,bias,sigma] = photerrors(m,fake);
mb = m+bias;
Floc = w .* LFmodel(X,m).*compl;
fint = sum( Floc .* (normcdf(B,mb,sigma)-normcdf(A,mb,sigma)) );
Floc = Floc ./ (sqrt(2*pi)*sigma) ;
Floc(isnan(Floc))=0;
f = zeros(size(mag));
for k=1:length(mag)
    f(k) = sum( Floc .* exp( -0.5*((mag(k)-mb)./sigma).^2 ) ) ;
end;



function [X,W] = XWg24(A,B,n)
%XWg24 Returns knots and weights for Gauss quadrature for 24 points.
%Knots and weights for interval [-1,1].
XX=[    0.064056892862605626085,...
        0.191118867473616309159,...
        0.315042679696163374387,...
        0.433793507626045138487,...
        0.545421471388839535658,...
        0.648093651936975569252,...
        0.740124191578554364244,...
        0.820001985973902921954,...
        0.886415527004401034213,...
        0.938274552002732758524,...
        0.974728555971309498198,...
        0.995187219997021360180    ];
XX = [XX, -XX];
WW=[    0.127938195346752156974,...
        0.125837456346828296121,...
        0.121670472927803391204,...
        0.115505668053725601353,...
        0.107444270115965634783,...
        0.097618652104113888270,...
        0.086190161531953275917,...
        0.073346481411080305734,...
        0.059298584915436780746,...
        0.044277438817419806169,...
        0.028531388628933663181,...
        0.012341229799987199547    ];
%Compute X,W in N parts of [A,B].
AB = linspace(A,B,n+1);
X = [];
for k=1:n
    X = [X, (AB(k+1)-AB(k))/2*XX+(AB(k+1)+AB(k))/2];
end;
W = repmat([WW,WW],1,n);
W = W * (B-A)/2/n;



%------------------------
function Y=LFrnd(X,N,FAKE)
F1 = (1-10.^(-2*X(4))) ./ (X(4).*log(10));
F2 = (10.^(2*X(2))-1) .* 10.^X(3) ./ (X(2).*log(10));
Ftot = F1+F2;

xx = rand(N,1).*Ftot;
p = xx<F1;
Y(p) = log10( xx(p) .* X(4).*log(10) + 10.^(-2*X(4)) ) ./ X(4) ;
Y(~p) = log10( (xx(~p) - F1).*X(2).*log(10)./10.^X(3) + 1 ) ./ X(2) ;
Y = Y+X(1);

if exist('FAKE','var')
    [c,b,s] = photerrors(Y,FAKE);
    p = rand(size(Y))>c;
    Y(p) = [];
    c(p) = [];
    b(p) = [];
    s(p) = [];

    Y = normrnd(Y+b,s);
end;