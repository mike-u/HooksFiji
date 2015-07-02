//filepath=File.openDialog("Select the first jpg File");
//filepathLength=lengthOf(filepath);
timesRun=0;
setBatchMode(true);
//channelExtension=filepath(filepathLength-8,filepathLength)
//directPath=File.openDialog

//channelExtension=substring(filepath,filepathLength-8,filepathLength-4)+".jpg"; //will always be 4 chars
input=getDirectory("choose a directory");

runtimes=newArray(1,2,4,5);	//how many channels to stack separately
for(timesRun=0; timesRun<runtimes.length; timesRun++){
channelExtension="Ch0"+runtimes[timesRun];

someMetadata="ztr3";	//this should be renamed
addToTifName="";	//probably needs to be initialized
/*imageDir=File.directory;
  imageName=File.getName(imageDir);
  parentName=File.getParent(imageDir);
  fileList = getFileList(imageDir);
  print("We found " + fileList.length + " images");	*/
numberSlice=0;

fileList=getFileList(input);
print("We found " + fileList.length + " images");

for(i=0; i<fileList.length; i++){
	if (indexOf(fileList[i], channelExtension)>0){
		if (endsWith(fileList[i], ".jpg")){
			numberSlice+=1;
			//print("numberSlice = " + numberSlice);

			if(numberSlice==1){
				filepath=input+fileList[i];
				print("filepath = " + filepath);
			}
			print("found " + fileList[i]);
		}
	}
}

//for(int i=1;i<fileList.length;i++){	//todo: we need to be able to tell how many files contain "ch05" in them	

//numberSlice=fileList.length;	//4 channels
//numberSlice=fileList.length/4;	//4 channels

scale=10; //how much to scale down images, default manually is 100
//print("we are about to run Image Seq");
//open(filepath);
run("Image Sequence...", 
		"open=[&filepath]"+
		" number="+numberSlice+
		" starting=1"+
		" increment=1"+
		" scale=10 "+
		"file=["+channelExtension+"] "+//Substring(
"sort");//takes values for image sequence

addToTifName=substring(input,0,3);

tifFormattedName="D"+toString(scale)+"_"+addToTifName+"_"+substring(File.getName(input),0,3)+".tif";
tifSavePath=input+tifFormattedName;

//tifFormattedName="D"+scale+substring(filepath,0,filepathLength-8);
saveAs("tiff", tifSavePath);
print("Saving to: "+tifSavePath);
}