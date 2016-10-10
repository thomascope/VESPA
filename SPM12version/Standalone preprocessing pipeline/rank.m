function r = rank(A,tol)
%HACK VERSION!!! To deal with large datasets. 

s = svd(A);
% if nargin==1
%    tol = max(size(A)) * eps(max(s));
% end
if nargin==1
   tol = max(size(A)) * eps(max(s));
   tol = min(tol, 1000);
end
r = sum(s > tol);
