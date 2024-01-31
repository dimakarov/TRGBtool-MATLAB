function [err,varargout] = getargs(parnames,defaults,varargin)
%GETARGS Process parameter name/value pairs (based on STATGETARGS)
err = '';
varargout = defaults;

npars = length(parnames);

%Check ambiguity
for k=1:npars
    if length( strmatch(parnames{k},parnames) ) > 1
        err = sprintf('Ambiguous parameter name:  %s.',parnames{k});
        return;
    end;
end;

nargs = length(varargin);

%Must have name/value pairs
if mod(nargs,2)~=0
    err = 'Wrong number of arguments.';
    return;
end;

%Process name/value pairs
for k=1:2:nargs
    pname = varargin{k};
    if ~ischar(pname)
        err = 'Wrong number of arguments.';
        return;
    end;
    i=strmatch(lower(pname),parnames);
    if ~isempty(i)
        varargout{i} = varargin{k+1};
    end;
end;