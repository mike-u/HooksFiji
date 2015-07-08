/*FIJI macro for stacking and thresholding images
 * Point to ImagesToAnalyse directory in GENSAT when you run it
 * 
 * In the log that appears when running, there is a bug where double-clicking the statuses will 
 * give an error as if you wanted to open a file by that name
 * */
 
setBatchMode(true);
input=getDirectory("choose a directory");

print(substring(File.getName(input),0,3));
runtimes=newArray(1,2,4,5);	//how many channels to stack separately
Dialog.create("File type");
suffix = ".tif" //the file extension we care about. Needs to be Ch0*.tif
timesSeq=0;

types=newArray("sequencing","threshing");	//we need to refresh the file list once we add tifs to it
threshMethods=newArray("MaxEntropy","Li","Mean","MinError(I)");

for(timesThrough=0;timesThrough<types.length;timesThrough++){
	timesSeq=0;
	processType=types[timesThrough];
	processFolder(input, processType);
}

function processFolder(input, processType) {
	list = getFileList(input);	//creates an array of filenames - we need to make a new list after adding files
	for (i = 0; i < list.length; i++) {
		//print("working at "+list[i]);	//pwd
		if (endsWith(list[i], "/")){	//if list[i] is a directory
			timesSeq=0;
			processFolder("" + input + list[i], processType);	//recursive call to process subdirectories
		}
		if (endsWith(list[i], ".tif") && processType=="threshing" && indexOf(list[i], "autothresh")<0)
		{	//if list[i] is a tif
			autothresh(input, list[i]);
		}	//we can't access files we make during loop
		if (endsWith(list[i], ".jpg") && indexOf(list[i],"001")>0 && processType=="sequencing" && timesSeq==0)	//this grabs the first jpg of each channel only as the starting
		{
			imgSequence(input, list[i]);
			timesSeq++;	//needs to be reset after each folder is traversed
		}
	}
}

function autothresh(input, file) {
	for(m=0;m<threshMethods.length;m++){
	method=threshMethods[m]; //type of auto thresholding
	print("threshing "+method+" "+file);

	open(input+file);
	makeRectangle(1, 1, 1703, 1184);	//draws a rectangle very close to border of first image
	run("Crop");	//crops to rectange - fixes some images not being uniform dimensions
	run("Auto Threshold", "method="+method+" white stack use_stack_histogram");

	tiffSavePath= input+"autothresh"+method+file;
	print(tiffSavePath);
	saveAs("tiff",tiffSavePath);
	print("Saving "+method+" threshed to: " + tiffSavePath);
	}
}

function imgSequence(input, file){
	list=getFileList(input);
	print("list[i] = "+list[i]);
	for(timesRun=0; timesRun<runtimes.length; timesRun++){
		channelExtension="Ch0"+runtimes[timesRun];
		print("channelExtension = "+channelExtension);
		print(timesRun);
		numberSlice=0;
		fileList=getFileList(input);

		for(i=0; i<fileList.length; i++){	//this loop gets us the number of slices we need
			if (indexOf(fileList[i], channelExtension)>0){
				if (endsWith(fileList[i], ".jpg")){
					numberSlice+=1;
					if(numberSlice==1){
						filepath=input+fileList[i];
						print("filepath = " + filepath);
					}
					//print("found " + fileList[i]);
				}
			}
		}
		print("found "+numberSlice+" of "+channelExtension);
		if(numberSlice!=0){
		
		scale=10; //how much to scale down images, default manually is 100
		jpgChannel=channelExtension+".jpg";
		print("stacking");
		run("Image Sequence...", 
				"open=[&filepath]"+
				" number="+numberSlice+
				" starting=1"+
				" increment=1"+
				" scale=10 "+
				"file=["+jpgChannel+"] "+//Substring(
			"sort");	//takes values for image sequence

		tifFormattedName="D"+toString(scale)+"_"+substring(File.getName(input),0,3)+"_"+channelExtension+"_stacked.tif";
		tifSavePath=input+tifFormattedName;
		saveAs("tiff", tifSavePath);
		print("Saving stacked to: "+tifSavePath);
		print(tifFormattedName);
		}
		else{
			print("there were no slices of channel "+channelExtension);
		}
	}
}

//now we attempt to save log as a .txt
//logResults=getInfo("log");
