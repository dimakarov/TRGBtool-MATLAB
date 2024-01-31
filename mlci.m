function ci = mlci(mlfun,X0,L,alpha,varargin)
%MLCI Maximum Likelihood Confidence Interval on parameters of model.
%   CI = MLCI(MLFUN,X0) returns the 95% confidence interval CI
%   on parameter extimate X0 of the maximum likelihood function MLFUN
%
%   CI = MLCI(MLFUN,X0,L) does not computes the maximum likelihood
%   value at parameter X0, but uses L value instead.
%
%   CI = MLCI(MLFUN,X0,L,ALPHA) computes confidence interval at 
%   (1-ALPHA) confidence level. ALPHA has a default of 0.05.
%
%   CI = MLCI(MLFUN,X0,L,ALPHA,P1,P2,...) passes the problem-dependent
%   parameters P1,P2,... directly to the function MLFUN, e.g. MLFUN
%   would be called using feval as in: feval(MLFUN,X,P1,P2,...).
%   Pass an empty matrix for L and ALPHA to use the default values.

%initialization
if (nargin<4 | isempty(alpha)),  alpha=0.05; end;  % 95% conf intervals
if (nargin<3 | isempty(L)),  L=feval(mlfun,X0,varargin{:}); end;  % minimum of maximum likelihood function

CL = chi2inv(1-alpha,length(X0))/2;
L = L + CL;

ci = NaN+zeros(length(X0),2);

for k=1:length(X0)
    [a,b,fa,fb] = GetRightInterval(@flocal,X0(k),-CL, k,X0,L,mlfun,varargin{:});
    ci(k,2)=GetFZero(@flocal,[a,b],[fa,fb], k,X0,L,mlfun,varargin{:});
    a = X0(k)-1.2*(ci(k,2)-X0(k));
    [a,b,fa,fb] = GetLeftInterval(@flocal,X0(k),-CL, a, k,X0,L,mlfun,varargin{:});
    ci(k,1)=GetFZero(@flocal,[a,b],[fa,fb], k,X0,L,mlfun,varargin{:});
end;





function Y=flocal(xi,i,X,L,fun,varargin)
X(i) = xi;
Y = feval(fun,X,varargin{:})-L;


function [a,b,fa,fb] = GetRightInterval(fun,a,fa,varargin)
%maximum likelihood function is roughly parabolic nearby minimum
dx = 0.1*(1+abs(a));
b = a+dx;
fb = feval(fun,b,varargin{:});
if fb<0
    dx = sqrt(abs(-fa./(fb-fa))).*(b-a);
    x = a+1.2*dx;
    a=b; fa=fb; b=x;
    fb = feval(fun,b,varargin{:});
    while fb<0
        x = (fb.*a - fa.*b)./(fb-fa) + 0.1.*(b-a);
        a=b; fa=fb; b=x;
        fb = feval(fun,b,varargin{:});
    end;
end;

function [a,b,fa,fb] = GetLeftInterval(fun,b,fb,a,varargin)
fa = feval(fun,a,varargin{:});
while fa<0
    x = (fb.*a - fa.*b)./(fb-fa) - 0.1.*(b-a);
    b=a; fb=fa; a=x;
    fa = feval(fun,a,varargin{:});
end;

function [b]=GetFZero(fun,X,F,varargin)
a=X(1); b=X(2); fa=F(1); fb=F(2);
tol = sqrt(eps);
% Main loop copied from fzero procedure.
fc = fb;
while fb ~= 0
   % Insure that b is the best result so far, a is the previous
   % value of b, and c is on the opposite of the zero from b.
   if (fb > 0) == (fc > 0)
      c = a;  fc = fa;
      d = b - a;  e = d;
   end
   if abs(fc) < abs(fb)
      a = b;    b = c;    c = a;
      fa = fb;  fb = fc;  fc = fa;
   end
   
   % Convergence test and possible exit
   m = 0.5*(c - b);
   toler = 2.0*tol*max(abs(b),1.0);
   if (abs(m) <= toler) | (fb == 0.0), 
      break, 
   end
   
   % Choose bisection or interpolation
   if (abs(e) < toler) | (abs(fa) <= abs(fb))
      % Bisection
      d = m;  e = m;
      step='       bisection';
   else
      % Interpolation
      s = fb/fa;
      if (a == c)
         % Linear interpolation
         p = 2.0*m*s;
         q = 1.0 - s;
      else
         % Inverse quadratic interpolation
         q = fa/fc;
         r = fb/fc;
         p = s*(2.0*m*q*(q - r) - (b - a)*(r - 1.0));
         q = (q - 1.0)*(r - 1.0)*(s - 1.0);
      end;
      if p > 0, q = -q; else p = -p; end;
      % Is interpolated point acceptable
      if (2.0*p < 3.0*m*q - abs(toler*q)) & (p < abs(0.5*e*q))
         e = d;  d = p/q;
         step='       interpolation';
      else
         d = m;  e = m;
         step='       bisection';
      end;
   end % Interpolation
   
   % Next point
   a = b;
   fa = fb;
   if abs(d) > toler, b = b + d;
   else if b > c, b = b - toler;
      else b = b + toler;
      end
   end
   fb = feval(fun,b,varargin{:});

end % Main loop