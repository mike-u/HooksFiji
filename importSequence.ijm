
filepath=File.openDialog("Select the first jpg File");
filepathLength=lengthOf(filepath);
setBatchMode(true);
//channelExtension=filepath(filepathLength-8,filepathLength)
//directPath=File.openDialog
do{
	channelExtension=substring(filepath,filepathLength-8,filepathLength-4)+".jpg"; //will always be 4 chars

	someMetadata="ztr3";	//this should be renamed
	addToTifName="";	//probably needs to be initialized
	imageDir=File.directory;
	imageName=File.getName(imageDir);
	parentName=File.getParent(imageDir);
	fileList = getFileList(imageDir);
	print("We found " + fileList.length + " images");
	numberSlice=0;

	 for(i=0;i<fileList.length;i++){
	 	if (indexOf(fileList[i], channelExtension)>0 && endsWith(fileList[i], ".jpg"))
	 		numberSlice++;
	 		print("found " + fileList[i]);
	 }

	//for(int i=1;i<fileList.length;i++){	//todo: we need to be able to tell how many files contain "ch05" in them	

	//numberSlice=fileList.length;	//4 channels
	//numberSlice=fileList.length/4;	//4 channels

	scale=10; //how much to scale down images, default manually is 100
	run("Image Sequence...", 
			"open=[&filepath]"+
			" number="+numberSlice+
			" starting=1"+
			" increment=1"+
			" scale=10 "+
			"file=["+channelExtension+"] "+//Substring(
		"sort");//takes values for image sequence

			doWeHaveThatMetadata=substring(imageName,4,8);
			if (doWeHaveThatMetadata==someMetadata){//if ztr3 is in the parent directory name
			addToTifName+=substring(getTitle,0,24);
			whatPath="did";
			}
			else{//ztr3 is not in parent directory
			addToTifName+=substring(getTitle,0,20);
			whatPath="didnt";
			}
			tifFormattedName="D"+toString(scale)+"_"+addToTifName+"_"+substring(channelExtension,0,4)+".tif";
			tifSavePath=imageDir+tifFormattedName;

			//tifFormattedName="D"+scale+substring(filepath,0,filepathLength-8);
			saveAs("tiff", tifSavePath);
			print("Saving to: "+tifSavePath);

			//saveAs("tiff");

			channelExtensionLast=substring(channelExtension,channelExtension-5,channelExtension-4);

			if (channelExtensionLast=="1")
				channelExtension="Ch02";
			else if (channelExtensionLast=="2")
				channelExtension="Ch04";
			else if (channelExtensionLast=="Ch04")
				channelExtension="Ch05";
			else
				toContinue=false;
}while (toContinue);
)
//}
