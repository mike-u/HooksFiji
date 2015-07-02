setBatchMode(true);
input=getDirectory("choose a directory");
output=input;
print(substring(File.getName(input),0,3));

runtimes=newArray(1,2,4,5);	//how many channels to stack separately

Dialog.create("File type");
//Dialog.addString("File suffix: ", ".tif", 5);
//Dialog.show();
suffix = ".tif" //Dialog.getString();	//the file extension we care about. Needs to be Ch0*.tif
doneID="_autothresh";

processFolder(input);

function processFolder(input) {
	setBatchMode(true);
	list = getFileList(input);
	for (i = 0; i < list.length; i++) {
		//if(File.isDirectory(list[i]))
		if (endsWith(list[i], "/"))
			processFolder("" + input + list[i]);
		if(endsWith(list[i], suffix)){	//every time we come to a tif, we process it
			if (indexOf(list[i],"autothresh")<0){
				autothresh(input, output, list[i]);
			}
		}
		if ((endsWith(list[i], ".jpg")) && indexOf(list[i],"001")>0){
			timesRun=0;
			for(timesRun=0; timesRun<runtimes.length; timesRun++){
				channelExtension="Ch0"+runtimes[timesRun];
				numberSlice=0;
				fileList=getFileList(input);
				//print("We found " + fileList.length + " images");

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
				jpgChannel=channelExtension+".jpg";
				run("Image Sequence...", 
						"open=[&filepath]"+
						" number="+numberSlice+
						" starting=1"+
						" increment=1"+
						" scale=10 "+
						"file=["+jpgChannel+"] "+//Substring(
					"sort");//takes values for image sequence

				//addToTifName=substring(input,0,3);
				tifFormattedName="D"+toString(scale)+"_"+substring(File.getName(input),0,3)+"_"+channelExtension+".tif";
				tifSavePath=input+tifFormattedName;
				saveAs("tiff", tifSavePath);
				print("Saving to: "+tifSavePath);
			}
		}
	}
}


function autothresh(input, output, file) {
	// do the processing here by replacing
	// the following two lines by your own code
	open(input+file);
	makeRectangle(1, 1, 1703, 1184);	//draws a rectangle very close to border of first image
	run("Crop");	//crops to rectange - fixes some images not being uniform dimensions
	run("Auto Threshold", "method=MaxEntropy white stack use_stack_histogram");
	//print("Processing: " + input + file);
	//print("Saving to: " + output);
	//run("Save");
	tiffSavePath= input+"autothresh"+file;
	saveAs("tiff",tiffSavePath);
	print("Saving to: " + tiffSavePath);
}
