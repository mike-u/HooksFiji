timesRun=0;
setBatchMode(true);
input=getDirectory("choose a directory");

runtimes=newArray(1,2,4,5);	//how many channels to stack separately
for(timesRun=0; timesRun<runtimes.length; timesRun++){
channelExtension="Ch0"+runtimes[timesRun];

numberSlice=0;

fileList=getFileList(input);
print("We found " + fileList.length + " images");

for(i=0; i<fileList.length; i++){
	if (indexOf(fileList[i], channelExtension)>0){
		if (endsWith(fileList[i], ".jpg")){
			numberSlice+=1;
		
			if(numberSlice==1){
				filepath=input+fileList[i];
				print("filepath = " + filepath);
			}
			print("found " + fileList[i]);	//used for testing to make sure it grabs the right images
		}
	}
}
scale=10; //how much to scale down images, default manually is 100

run("Image Sequence...", 
		"open=[&filepath]"+
		" number="+numberSlice+
		" starting=1"+
		" increment=1"+
		" scale=10 "+
		"file=["+channelExtension+"] "+//Substring(
"sort");//takes values for image sequence

//addToTifName=substring(input,0,3);
tifFormattedName="D"+toString(scale)+"_"+addToTifName+"_"+substring(File.getName(input),0,3)+".tif";
tifSavePath=input+tifFormattedName;
saveAs("tiff", tifSavePath);
print("Saving to: "+tifSavePath);
}