function exportRobot(robot,name)

%convert input to character array
name=convertStringsToChars(name);

folderName=['results/' name];
mkdir(folderName)

robotFile = fopen([folderName '/robot'],'w');

%print points
fprintf(robotFile,"%10.7f\n",robot.distLen);
fprintf(robotFile,"%10.7f\n",robot.proxLen);
fprintf(robotFile,"%10.7f,\t%10.7f,\t%10.7f\n",robot.bodyPos);
fprintf(robotFile,"%10.7f,\t%10.7f,\t%10.7f\n",robot.bodyRot);
fprintf(robotFile,"%10.7f\n",robot.bodyW);
fprintf(robotFile,"%10.7f\n",robot.bodyL);

end