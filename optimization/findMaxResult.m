function [xstars,fstars,orders,exitflags]=findMaxResult(orders,xstars,fstars,exitflags)
% findMaxResult finds the best shuffle and all those within .1 of it

%remove from consideration those which did not find a valid solution
fstars(exitflags==-2)=NaN;

%find the maximum
maxF=max(fstars);

%return all those results within the tolerance of the maximum
key=abs(fstars-maxF)<0.01;
xstars=xstars(key);
fstars=fstars(key);
orders=orders(key);
exitflags=exitflags(key);


end
