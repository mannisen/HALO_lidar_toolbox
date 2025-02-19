function std_y_f = bootstrpSE(nb,f,y,y_error)
%BOOTSTRPSTANDARDERROR draws 'nb' bootstrap data samples, computes 
%statistics on each sample using the function 'f', and estimates the 
%standard error from the results, which returned as 'std_e'.
%
%Inputs:
%-nb        positive integer, no. times replacements are drawn from data
%-f         function handle, e.g. @mean
%-y         vector or matrix, data
% OPTIONAL
%-y_error   vector or matrix, respective errors/uncertainties
%
%Outpus:
%-std_y_f   standard error of the given function calculated from the data
%
%Created 2017-11-18
% Antti Manninen
% University of Helsinki, Finland
% antti.j.manninen@helsinki.fi

% Check inputs
if ~isnumeric(nb) || ~isscalar(nb) || ~isfinite(nb)
    error('1st input must be a unmerical finite scalar.')
end
if ~isa(f, 'function_handle')
    error('2nd input must be a function handle.')    
end
if ~isnumeric(y(:)) || (~isvector(y) && ~ismatrix(y) && isscalar(y))
    error('3rd input must be a numerical finite vector of matrix.')
end
if nargin == 4
    if ~isnumeric(y(:)) || (~isvector(y) && ~ismatrix(y) && isscalar(y)) || ...
            size(y_error,1)~=size(y,1) || size(y_error,2)~=size(y,2)
        error(['4th input must be a numerical finite vector of matrix,'...
            ' and has to have the same dimensions with the 3rd input.'])
    end
end
% TBD: Check inputs & add CIs
bstats = nan(nb,size(y,2));
for i = 1:nb
    i_rs = ceil(size(y,1).*rand(size(y,1),1));
    if nargin < 4 % no weights
        bstats(i,:) = f(y(i_rs,:));
    else
        bstats(i,:) = f(y(i_rs,:),y_error(i_rs,:));
    end
end
std_y_f = nanstd(bstats);
end

