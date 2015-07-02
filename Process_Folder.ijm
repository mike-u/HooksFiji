/*
 * Macro template to process multiple images in a folder
 */

input = getDirectory("Input directory");
output = input;//getDirectory("Output directory");

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
		if(endsWith(list[i], suffix))	//every time we come to a tif, we process it
			if (indexOf(list[i],"autothresh")<0)
				processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
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
