function exportShuffle(order,pts,name)

%convert input to character array
name=convertStringsToChars(name);

folderName=['results/' name];
mkdir(folderName)

pointsFile = fopen([folderName '/points'],'w');
orderFile = fopen([folderName '/order'],'w');

%print points
fprintf(pointsFile,"%10.7f\t%10.7f\t%10.7f\t\n",pts');

%print order
fprintf(orderFile,"%3i\n",order);

end