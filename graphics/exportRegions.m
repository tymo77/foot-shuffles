function exportRegions(regions,name)
%convert input to character array
name=convertStringsToChars(name);
Nsurfs=length(regions);

folderName=['results/' name '/surf'];
mkdir(folderName)

for i=1:Nsurfs
    ptsFile = fopen([folderName '/pts' num2str(i)],'w');
    triFile=fopen([folderName '/tri' num2str(i)],'w');
    
    %print points
    fprintf(ptsFile,"%10.7f\t%10.7f\t%10.7f\n",regions(i).mesh.points');
    
    %print order
    fprintf(triFile,"%6i\t%6i\t%6i\n",regions(i).mesh.tri');
    
end
end