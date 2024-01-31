function tab = tblselect(tab,cols,varargin)

Nargs=length(varargin);

%Must have name/value pairs
if mod(Nargs,2)~=0, error('Wrong number of arguments.'); end;
%Check ambiguity
ParInd = 1:2:Nargs;
for k=ParInd
    if sum( strcmpi( varargin{k},varargin(ParInd) ) ) > 1
        error( sprintf('Ambiguous parameter name:  %s.',varargin{k}) );
    end;
end;

p=logical(ones(size(tab(:,1))));
for k=ParInd
    if strcmp(varargin{k},'sharp')
        p = p & abs( tab(:,cols.(varargin{k})) ) <= varargin{k+1};
    else
        p = p & tab(:,cols.(varargin{k})) <= varargin{k+1};
    end;
end;
tab(~p,:) = [];