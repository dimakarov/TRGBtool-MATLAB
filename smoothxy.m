function [xi,yi,si,dfe] = smoothxy(x,y,varargin)
%SMOOTHXY smooth the response data
%
%   [Xi,Yi,Si,DFE]=SMOOTHXY(X,Y,Xi) Returns smoothed values Yi, 1-sigma
%   error Si and degrees of freedom DFE correspinding to the elements of Xi
%   and determined by smoothing the vectors X,Y.
%
%   [...]=SMOOTHXY(X,Y)
%
%   [...]=SMOOTHXY(X,Y,'par1',val1,...)
%   [...]=SMOOTHXY(X,Y,Xi,'par1',val1,...)

xi=[];
if length(varargin)>0 & isnumeric(varargin{1})
    xi = varargin{1};
    varargin(1)=[];
end;

pars = {'span','window', 'robust'};
defs = {    [],      [],     'on'};
[err,span,u,robust] = getargs(pars,defs,varargin{:});
error(err);

x=x(:);
y=y(:);
[x,ind] = sort(x);
y = y(ind);

if isempty(u)
    %Get window parameter
    u = median(abs(x-median(x))) / 0.6745 ;
    u = 3 * u * (4/(3*length(x)))^(1/5);
end;
if isempty(span)
    %Get Span
    span = max(floor(length(x)/50),5);
end;
span = min(span,length(x));
if isempty(xi)
    %Get Xi
    xi = linspace(min(x),max(x),100); 
end;
yi = zeros(size(xi));
si = yi;
dfe = yi;
%
seps=sqrt(eps);
lbound=zeros(size(xi));
rbound=lbound;
%
for i=1:length(xi)
    xc = xi(i);
    d=abs(x-xc);
    [dsort,idx] = sort(d);
    idx = idx( dsort<=max(dsort(span),u) );
    x1 = x(idx)-xc;
    y1 = y(idx);
    dsort = d(idx);
    dmax = max(dsort); if dmax==0, dmax=1; end;
    if robust
        lbound(i) = min(idx);
        rbound(i) = max(idx);
    end;
    
    weight = (1-(dsort/dmax).^3).^1.5;  %tri-cubic weight
    if all(weight<seps), 
        weight(:)=1; % if all weight are 0, just skip weighting
    end;
    
    %Weighted least-squares
    v = repmat(weight,1,2) .* [ones(size(x1)),x1];
    y1 = weight .* y1;
    [Q,R] = qr(v,0);
    b = R\(Q'*y1);
    yi(i) = b(1);
    %1-sigma error
    sse = sum( (y1-v*b).^2 ) ;  % sum squared of error
    dfe(i) = length(y1)-2-1 ;   % degrees of freedom of error
    Rinv = R\eye(length(R));
    berr = sqrt( sum(Rinv.^2,2) .* sse./dfe(i) ) ;  % 1-sigma error
    si(i) = berr(1);
end;

% now that we have a non-robust fit, we can compute the residual and do
% the robust fit if required

if ~strcmp(robust,'on'), return; end;

iter=5;
for k=1:iter
    r = y-pchip(xi,yi,x);
    for i=1:length(xi)
        idx=lbound(i):rbound(i);
        x1 = x(idx)-xi(i);
        d = abs(x1);
        y1 = y(idx);
        r1 = r(idx);
        
        dmax = max(d); if dmax==0, dmax=1; end;
        weight = (1 - (d/dmax).^3).^1.5;  %tri-cubic weight
        % if all weight are 0, just skip weighting
        if all(weight<seps), weight(:)=1; end;
        
        r1 = abs(r1-median(r1));
        mad = median(r1);
        if mad > max(abs(y1))*eps
            dr = r1./(6*mad);
            rweight = (1-dr.*dr);
            rweight(dr>1) = 0;
            weight = weight.*rweight;
        end;
        
        %Weighted least-squares
        v = repmat(weight,1,2) .* [ones(size(x1)),x1];
        y1 = weight .* y1;
        [Q,R] = qr(v,0);
        b = R\(Q'*y1);
        yi(i) = b(1);
        %1-sigma error
        sse = sum( (y1-v*b).^2 ) ;  % sum squared of error
        dfe(i) = length(y1)-2-1 ;   % degrees of freedom of error
        Rinv = R\eye(length(R));
        berr = sqrt( sum(Rinv.^2,2) .* sse./dfe(i) ) ;  % 1-sigma error
        si(i) = berr(1);
    end;
end;