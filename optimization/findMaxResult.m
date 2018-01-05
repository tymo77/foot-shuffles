function [xstars,fstars,orders,exitflags]=findMaxResult(orders,xstars,fstars,exitflags)

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
