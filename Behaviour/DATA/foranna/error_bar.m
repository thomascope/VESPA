function han = error_bar(in_m, in_s,cvec1,cvec2,flag,wid)

% function han = error_bar(in_m, in_s,color,errcolor,flag,wid)
% 
% for given input vectors mean and sd it will draw bars and errorbars
% at fixed distance in the current axis.
% % color can be a vector of colors
%
% it returns a hande cell array.
 
if nargin<2
  fprintf('two arguments required\n');
  return;
end

if length(in_m)~=length(in_s)
  fprintf('two inputs must have the same dimension\n');
  return;
end
if nargin > 5
  w = wid;
else
  w = 1;
end
if nargin > 4 
  flag1 = flag;
else
  flag1 = 0;
end
if nargin>2
  if ~isempty(cvec1)
    cvec = cvec1;
  else 
    cvec = 'k';
  end
else
  cvec = 'k';
end
if nargin>3
  if ~isempty(cvec1)
    cvec2 = cvec1;
  else 
    cvec2 = 'k';
  end
else
  cvec2 = 'k';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


n = length(in_m);
X = [1:n];
d = 0.3;
d1 = 1/3;
hold on;
for k=1:n
  if length(cvec)==n
    cc = cvec(k);
  else
    cc = cvec(1);
  end
  if length(cvec2)==n
    cc2 = cvec2(k);
  else
    cc2 = cvec2(1);
  end
  if any(in_m(k))
    if flag1
      han = line([X(k)-d1,X(k)-d1,X(k)+d1,X(k)+d1,X(k)-d1],[0,in_m(k),in_m(k),0,0],'Color',cc);
      set(han,'LineWidth',w);
    else
      bar(X(k),in_m(k),cc);
    end
    % vertical line
    han = line([X(k),X(k)],[in_m(k)+in_s(k),in_m(k)-in_s(k)],'Color',cc2);
    set(han,'LineWidth',w);
    % horizontal lines
    han = line([X(k)-d,X(k)+d],[in_m(k)+in_s(k),in_m(k)+in_s(k)],'Color',cc2);
    set(han,'LineWidth',w);
    han = line([X(k)-d,X(k)+d],[in_m(k)-in_s(k),in_m(k)-in_s(k)],'Color',cc2);
    set(han,'LineWidth',w);
  end
end

  





