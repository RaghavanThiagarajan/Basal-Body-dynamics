// Raghavan Thiagarajan, 27th December, DanStem, Copenhagen

//==========================================================================================================================================================================================================================================================================================================//

// Data organization

Path0 = getInfo("image.directory"); 
Path = File.getParent(Path0);
dir0 = Path+"/data/"; File.makeDirectory(dir0); 
dir0_0 = dir0+"/Gradients_of_actin_intensity/"; File.makeDirectory(dir0_0); 
dir1=dir0+"/Background_actin_intensity_ROI_data/"; File.makeDirectory(dir1); 
dir1_1=dir1+"/Full_Measure/"; File.makeDirectory(dir1_1);
dir2=dir0_0+"/Whole_ROI_Measure/"; File.makeDirectory(dir2);
dir3=dir0_0+"/Discretized_ROI_Results/"; File.makeDirectory(dir3);

dir4=dir3+"/Discretized_ROI_Full_Measure/"; File.makeDirectory(dir4);
dir5=dir4+"/Left-to-right_direction/"; File.makeDirectory(dir5);
dir6=dir4+"/Top-bottom_direction/"; File.makeDirectory(dir6);
dir7=dir4+"/Local_discretization/"; File.makeDirectory(dir7);

dir8=dir3+"/Discretized_ROI_Cell_width/"; File.makeDirectory(dir8);
dir9=dir8+"/Left-to-right_direction/"; File.makeDirectory(dir9);
dir10=dir8+"/Top-bottom_direction/"; File.makeDirectory(dir10);
dir11=dir8+"/Local_discretization/"; File.makeDirectory(dir11);

dir12 = dir0_0+"/Cortex_intensity_ROI_data/"; File.makeDirectory(dir12); 
dir12_1=dir12+"/Full_Measure/"; File.makeDirectory(dir12_1);

// User Prompt
Dialog.create("Message");
Dialog.addMessage("Keep ready the value by which the area contour was shifted / reduced to avoid \n       cortex from the analysis; You will enter this value in the next prompt", 20);
Dialog.show;
Dialog.create("How should \n the ROI change ?");
Dialog.addNumber("Shift value [in µm]:", 000);
Dialog.show;
ROI_shift_value = Dialog.getNumber();
ROI_shift_value = ROI_shift_value * (-1); // Value is made negative to shift the ROI inwards i.e. to decrease the ROI

//==========================================================================================================================================================================================================================================================================================================//

run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");
Stack.getDimensions(width, height, channels, slices, frames); totalslices = slices; totalframes = frames;
setOption("ExpandableArrays", true);
if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
}
// We select an area and measure the background intensity
waitForUser("From the raw data, select an area outside the ROI for calculating \nmean backgorund intensity and then click \"OK\"");
roiManager("add"); 
Background_meanintensity=newArray;
setBatchMode(true);
for (t=1; t<=totalframes; t++) {
	for (n=1; n<=totalslices; n++) {
		selectWindow("Actin_gradient_rawdata.tif");
		roiManager("select", 0);
		Stack.setPosition(1, n, t);
		run("Measure");
	}
selectWindow("Results"); saveAs("results", dir1_1 +"Measure_background_results_t_" +t+ ".txt"); close("Results");
}
setBatchMode(false);
selectWindow("ROI Manager"); roiManager("save", dir1 +"ROI_Backgroundintensity" + ".roi"); run("Close");
selectWindow("Actin_gradient_rawdata.tif"); run("Close");

//==========================================================================================================================================================================================================================================================================================================//

// Image dimensions are obtained
getDisplayedArea(x, y, width, height);  imagewidth = width; imageheight = height;
getPixelSize(unit, pixelWidth, pixelHeight);
getVoxelSize(width, height, depth, unit);
Time_interval = Stack.getFrameInterval();
print("Image"+"\t"+"Image"+"\t"+"Pixel"+"\t"+"Pixel"+"\t"+"Time"+"\t"+"Total"+"\t"+"Total"+"\t"+"Voxel"+"\n"+"width"+"\t"+"height"+"\t"+"width"+"\t"+"height"+"\t"+"Interval"+"\t"+"frames"+"\t"+"slices"+"\t"+"depth"+"\n"+ imagewidth+"\t"+ imageheight+"\t"+pixelWidth+"\t"+pixelHeight+"\t"+Time_interval+"\t"+totalframes+"\t"+totalslices+"\t"+depth);
selectWindow("Log"); saveAs("Text", dir0_0 +"Image_dimensions" + ".txt"); run("Close"); 

//==========================================================================================================================================================================================================================================================================================================//

// Shifting the ROI obtained from thresholding, so that only the actin intensities (for gradients plot) inside the cortex of the cell are obtained.

roiManager("open", Path0 +"RoiSet_actin_thresholded" + ".roi");
ROI_count = roiManager("count");
setBatchMode(true);
for (rr=1; rr<=ROI_count; rr++) {
		roiManager("select", rr-1);
		run("Enlarge...", "enlarge=ROI_shift_value"); // This number corresponds to the number of pixels to be shifted. This number needs to be converted to micrometers if the image properties is set in micrometers
        roiManager("update");
}
selectWindow("ROI Manager"); roiManager("save", dir0_0 +"ROI_gradient_of_actin_intensity" + ".roi"); run("Close");
setBatchMode(false);	

//==========================================================================================================================================================================================================================================================================================================//

// Using combination of ROI's (from thresholding and ROI shifting), a new "combined ROI" is obtained to mark the cortex so that cortical intensity can be obtained. 
// This cortical mean intensity will be used for normalization and if needed the ROI of cortex can be used for future analysis.

roiManager("open", Path0 +"RoiSet_actin_thresholded" + ".roi");
ROI_count = roiManager("count");
setBatchMode(true); 
for (t = 1; t <= totalframes; t++) {
	for (s = 1; s <= totalslices; s++) {
		Stack.setPosition(1, s, t);
		roiManager("select", 0);
		run("Enlarge...", "enlarge=ROI_shift_value"); // This number corresponds to the number of pixels to be shifted. This number needs to be converted to micrometers if the image properties is set in micrometers
		selectWindow("Actin_gradient.tif"); roiManager("add"); ROIcount = roiManager("count");
		roiManager("select", newArray(0,(ROIcount-1)));
		roiManager("xor"); 
		run("Measure");
		roiManager("add"); ROIcount = roiManager("count");
		roiManager("select", newArray(0,(ROIcount-2)));
		roiManager("delete");
	}
	selectWindow("Results"); saveAs("results", dir12_1 +"Mean_Intensity_t_"+t+ ".txt"); close("Results");
}
setBatchMode(false);	
selectWindow("ROI Manager"); roiManager("save", dir12 +"ROI_for_cortex" + ".roi"); run("Close");

//==========================================================================================================================================================================================================================================================================================================//

// Full ROI measure without any discretization

Cell_width = newArray; Mean_intensity = newArray;   
roiManager("open", Path0 +"RoiSet_actin_thresholded" + ".roi");
setBatchMode(true);
for (t=1; t<=totalframes; t++) {
	for (n=1; n<=totalslices; n++) {
		roiManager("select", 0);
		Stack.setPosition(1, n, t);
		run("Measure");
		roiManager("delete");
	}
	selectWindow("Results"); saveAs("results", dir2 +"whole_roi_measure_t" +t+ ".txt"); close("Results");
}
setBatchMode(false);

//===================================================================================================================================//

// THEN WE SELECT ROI AND PERFORM DISCRETIZATION OF ROI

if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
}
roiManager("open", dir0_0 +"ROI_gradient_of_actin_intensity" + ".roi");
setBatchMode(true);
for (t=1; t<=totalframes; t++) {
	for (n=1; n<=totalslices; n++) {

		//===================================================================================================================================//

		// First: we perform discretization in the left-to-right direction - 
		
		roiManager("select", 0); 
		Stack.setPosition(1, n, t); 
		Cell_width = newArray; 
		Roi.getBounds(x, y, width, height); 
		check_Leftright(); // Calling the function check() - which is below.
		for (increment=0; increment<width; increment=increment+10) {
			makeRectangle(x+increment, y, 10, height);
			roiManager("add"); Roicount=roiManager("count"); 
			roiManager("select", newArray(0,(Roicount-1)));
			roiManager("and"); 
			roiManager("add"); Roicount=roiManager("count"); 
			roiManager("select", (Roicount-1));
			run("Measure");  //run("Draw", "Slice");
			h=nResults;
			Cell_width[h-1] = increment+5;
			roiManager("select", (Roicount-1)); roiManager("delete");
			Roicount=roiManager("count"); 
			roiManager("select", (Roicount-1)); roiManager("delete");	
			if (increment >= (width-10)) {
				Table.showArrays("Cell_width", Cell_width);
				//Array.show(Mean_intensity); Array.show(Cell_width);
			}		
		}
		selectWindow("Results"); saveAs("results", dir5 +"L-R_Fullmeasure_t_" + t +"_slice_"+ n + ".txt"); close("Results");
		selectWindow("Cell_width"); Table.save(dir9+"L-R_Cellwidth_t_"+ t +"_slice_"+ n +".txt"); run("Close");
		

        //===================================================================================================================================//

        // Second: we perform discretization in the top-bottom direction - 

        roiManager("select", 0); 
		Stack.setPosition(1, n, t);
		Cell_width = newArray; 
		Roi.getBounds(x, y, width, height); 
		check_Topbottom(); // Calling the function check() - which is below.
		for (increment=0; increment<height; increment=increment+10) {
			makeRectangle(x, y+increment, width, 10);
			roiManager("add"); Roicount=roiManager("count"); 
			roiManager("select", newArray(0,(Roicount-1)));
			roiManager("and"); 
			roiManager("add"); Roicount=roiManager("count"); 
			roiManager("select", (Roicount-1));
			run("Measure"); //run("Draw", "Slice");
			h=nResults;
			Cell_width[h-1] = increment+5;
			roiManager("select", (Roicount-1)); roiManager("delete");
			Roicount=roiManager("count"); 
			roiManager("select", (Roicount-1)); roiManager("delete");
			if (increment >= (height-10)) {
				Table.showArrays("Cell_width", Cell_width);
				//Array.show(Mean_intensity); Array.show(Cell_width);
			}					
		}
		selectWindow("Results"); saveAs("results", dir6 +"T-B_Fullmeasure_t_" + t +"_slice_"+ n + ".txt"); close("Results");
		selectWindow("Cell_width"); Table.save(dir10+"T-B_Cellwidth_t_"+ t +"_slice_"+ n +".txt"); run("Close");


        //===================================================================================================================================//

        // Third: we perform local discretizations (of 10 pixels x 10 pixels squares) all along the apical surface - 
        		
        roiManager("select", 0); 
        Stack.setPosition(1, n, t); 
        Cell_width = newArray; 
		Roi.getBounds(x, y, width, height); 
		check_Leftright(); // Calling the function check_Leftright() - which is below.
		check_Topbottom(); // Calling the function check_Topbottom() - which is below.
		for (incrementx=0; incrementx<width; incrementx=incrementx+10) {
			for (incrementy=0; incrementy<height; incrementy=incrementy+10) {
				makeRectangle(x+incrementx, y+incrementy, 10, 10); //run("Draw", "Slice");
				roiManager("add"); Roicount=roiManager("count"); 
				roiManager("select", newArray(0,(Roicount-1)));
				roiManager("and"); 
				if (selectionType==-1) {
					roiManager("deselect");
					roiManager("select", (Roicount-1)); roiManager("delete");	
				}
				else {
					roiManager("add"); Roicount=roiManager("count"); 
					roiManager("select", (Roicount-1));
					run("Measure"); //run("Draw", "Slice");
					h=nResults;
					Cell_width[h-1] = incrementx+5;
					roiManager("select", (Roicount-1)); roiManager("delete"); 
					Roicount=roiManager("count"); 
					roiManager("select", (Roicount-1)); roiManager("delete"); 
				}
			}
			if (incrementx >= width-10) {
				Table.showArrays("Cell_width", Cell_width);
			}
		}
		selectWindow("Results"); saveAs("results", dir7 +"Square_Fullmeasure_t_" + t +"_slice_"+ n + ".txt"); close("Results");
		selectWindow("Cell_width"); Table.save(dir11+"Square_Cellwidth_t_"+ t +"_slice_"+ n +".txt"); run("Close");   
		
        //===================================================================================================================================//
		roiManager("select", 0); 
		roiManager("delete");		
	}	
}
setBatchMode(false);
selectWindow("ROI Manager"); run("Close");

//===================================================================================================================================//

// Function for checking boundary condition --- Left to right

function check_Leftright() {
	if ((width%10) == 0) {
		width = width;
		return width; 		
	}
	else {
		width = width-1;
		return width;
	}	
}

// Function for checking boundary condition --- Top to Bottom

function check_Topbottom() {
	if ((height%10) == 0) {
		height = height;
		return height; 		
	}
	else {
		height = height-1;
		return height;
	}	
}


