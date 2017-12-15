function yi = mynormr(x)
%NORMR Normalize rows of matrices.
%
%  <a href="matlab:doc normr">normr</a>(X) takes a single matrix or cell array of matrices and returns
%  the matrices with rows normalized to a length of one.
%
%  Here the rows of a random matrix are normalized.
%
%    x = <a href="matlab:doc rands">rands</a>(4,8);
%    y = <a href="matlab:doc normr">normr</a>(x)
%
%  See also NORMC.

% Copyright 1992-2015 The MathWorks, Inc.


x(~isfinite(x)) = 0;
len = sqrt(sum(x.^2,2));
yi = bsxfun(@rdivide,x,len);
zeroRows = find(len==0);
if ~isempty(zeroRows)
    numColumns = size(x,2);
    row = ones(1,numColumns) ./ sqrt(numColumns);
    yi(zeroRows,:) = repmat(row,numel(zeroRows),1);
end


end
