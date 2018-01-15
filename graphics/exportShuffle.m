function exportShuffle(order,pts,methodName,problemName)

%convert input to character array
methodName=convertStringsToChars(methodName);
problemName=convertStringsToChars(problemName);

folderName=['results/' problemName '/' methodName];
mkdir(folderName)

pointsFile = fopen([folderName '/points'],'w');
orderFile = fopen([folderName '/order'],'w');

%print points
fprintf(pointsFile,"%10.7f\t%10.7f\t%10.7f\n",pts');

%print order
fprintf(orderFile,"%3i\n",order);

end