// Raghavan Thiagarajan, 13th October 2022, reNEW, Copenhagen
/*
 * This script is used to generate Z projected images of the t0 and tend position markings of BBs. The Z projections are performed 
 * over images that are within a 10 % area increment. Then the contours corresponding to every 10 % area increment is 
 * drawn on these images, and a stack and montage of these are saved. This script is used at the end of the BB analysis. 
 * This script is used only on "t0_basalbody_position_all" and "tend_basalbody_position_all" condition.
 */
//==========================================================================================================================================================================================================================================================================================================//
run("Close All");

// User prompt
waitForUser("You will run this script twice: \n (1) Open the image files in the folder 'bb_appearance_plot' in the directory:\n                    '/Plots/t0_basalbody_position_'number'minlongTraj/' \n                                              and then click 'OK' \n (2) Open the image files in the folder 'bb_disappearance_plot' in the directory:\n                    '/Plots/tend_basalbody_position_'number'minlongTraj/' \n                                              and then click 'OK'"); 

// Open the images from "bb_appearance_plot" and "bb_disappearance_plot" folders
id = getImageID();
selectImage(id);

// creating all directories
Path0 = getInfo("image.directory"); 
img_filename = File.getNameWithoutExtension(Path0);
Path1 = File.getParent(Path0); Path2 = File.getParent(Path1); Path3 = File.getParent(Path2); file_path = Path3 
dir1 = Path3 + "/data/";
if (img_filename == "bb_appearance_plot") {
	dir2 = Path1 + "/bb_appearance_plot_MIP/"; File.makeDirectory(dir2);
	dir4 = Path1 + "/bb_appearance_plot_MIP/";
	bb_dyn_name = "bb_appearance";
}
else {
	dir2 = Path1 + "/bb_disappearance_plot_MIP/"; File.makeDirectory(dir2);
	dir4 = Path1 + "/bb_disappearance_plot_MIP/";	
	bb_dyn_name = "bb_disappearance";
}
dir3 = Path3 + "/Input_Actin/";

// opening the rois of areas - the one that is generated in the beginning of the BB analysis
if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
}
roiManager("open", dir3 +"RoiSet_actin_thresholded" + ".zip");

// opening the .csv file that contains the list of frames with areas that are incremented by 10 %
open(dir1+"Area_percent.csv");
no_of_elements = getValue("results.count");

// creating a newArray into which the list of frames obtained from the .csv file will be stored
roiseq = newArray(no_of_elements);

// this for loop gets the list of all frames within a 10 % area increment so that a Maximum projection can be applied 
for (i = 0; i < no_of_elements-1; i++) {
	selectWindow("Area_percent.csv");
	current_idx = Table.get("Index_from_Area_apicaldomain", i);
	if (i == no_of_elements-2) {
		subsequent_idx = (Table.get("Index_from_Area_apicaldomain", i+1)); // for Z projection
		roiseq[i] = subsequent_idx-2; // for isolating the rois corresponding to the 10 % area increment
		roiseq[i+1] = subsequent_idx-1; // for isolating the rois corresponding to the 10 % area increment
	}
	else {
		subsequent_idx = (Table.get("Index_from_Area_apicaldomain", i+1)) - 1; // for Z projection
		roiseq[i] = subsequent_idx-1; // for isolating the rois corresponding to the 10 % area increment
	}
	// applying Z projection
	selectImage(id);
	run("Z Project...", "start="+current_idx+" stop="+subsequent_idx+" projection=[Max Intensity]");
	rename(i+".tif");
}
selectImage(id); run("Close");

// concatenating all the images from the Z projection
stk0 = "0.tif"; stk1 = "1.tif"; stk2 = "2.tif";
run("Concatenate...", "open image1=stk0 image2=stk1 image3=stk2 image4=[-- None --]");
for (t=3; t<=no_of_elements-2; t++) {
			stkname = ""+ t+".tif";
			run("Concatenate...", "open image1=[Untitled] image2="+stkname+" image3=[-- None --]");		
}
saveAs("tiff", dir4 + bb_dyn_name +"_MIP" + ".tif"); 

// saving all the rois corresponding to the 10 % area increment so that they all can be drawn on the Z projected images
// this will allow us to immediately see how the positioning of the new basal bodies are changing for every 10 % area change
selectWindow("ROI Manager");
roiManager("select", roiseq);
roiManager("save selected", dir4 +"ROI_" + bb_dyn_name + "_MIP" + ".zip"); run("Close");

// this for loop applies all the rois on all Z projected images to see how the positioning of the new basal bodies 
// are changing for every 10 % area change
setColor(255, 255, 255);
roiManager("open", dir4 +"ROI_" + bb_dyn_name + "_MIP" + ".zip");
for (i = 1; i < no_of_elements; i++) {
	//for (j = 0; j <= no_of_elements-1; j++) {
		roiManager("select", i-1);
		selectWindow(bb_dyn_name + "_MIP.tif");
		setSlice(i);
		run("Draw", "slice");
	//}
}
saveAs("tiff", dir4 + bb_dyn_name + "_MIP_contours" + ".tif"); 

// this for loop is to make a montage of the stack obtained from the previous loop
if (((no_of_elements - 1) % 2) == 0) {
	cols = (no_of_elements - 1) / 2;
}
else {
	cols = ((no_of_elements - 1) / 2) + 1;
}
rowss = 2;
run("Make Montage...", "columns="+cols+" rows="+rowss+" scale=1 font=30 label");
saveAs("tiff", dir4 + bb_dyn_name + "_montage_contours" + ".tif"); 

close("ROI Manager"); close("Area_percent.csv"); 

close("*"); // close all images

	
//-------------------- end-------------------------//

