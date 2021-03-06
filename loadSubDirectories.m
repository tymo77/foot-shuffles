function loadSubDirectories()
% loadSubDirectories  loads all subdirectories of the current directory
%   does not load sub-subdirectories etc.

currentFolderContents = dir(pwd);      %Returns all files and folders in the current folder
currentFolderContents (~[currentFolderContents.isdir]) = [];  %Only keep the folders

for i = 4:length(currentFolderContents)           %Start with 4 to avoid '.' and '..' and '.git'
    addpath(['./' currentFolderContents(i).name])
end
end