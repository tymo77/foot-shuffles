function exportInitPts(pts,name)

%convert input to character array
name=convertStringsToChars(name);

folderName=['results/' name];
mkdir(folderName)

pointsFile = fopen([folderName '/initPoints'],'w');

%print points
fprintf(pointsFile,"%10.7f\t%10.7f\t%10.7f\n",pts');


end