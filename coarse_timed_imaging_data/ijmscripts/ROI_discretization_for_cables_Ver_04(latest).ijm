// Raghavan Thiagarajan, 27th September 2024, reNEW, Copenhagen

// This script is an adaptation of 'ROI_discretization_hyperstack_Macro(Sampling=10px)_Actin_RT_Ver_04(latest).ijm'. This is used for analysing actin cables.
// It looks like the cables are initially present when the BBs are ascending. But the cables seem to disappear when the BBs have finished ascending. Since only
// the cables are disappearing and not the actin, there will not be appreciable change in actin intensity since the total amount of actin present will be the same.
// However, the the presence and absence of cables should show up in the variance in intensity across the image and across time. So the idea is to go to every frame
// and discretize the ROI (coul be: apical area / outside apical area / whole cell) of the cell into small boxes of (~ 10x10 pixels) and then collect the mean intensities
// from each of these boxes. This is what this script does. It discretizes each ROI (of a frame) into smaller boxes and collects the mean and total intensities along with
// some other parameters like Area, Kurtosis etc.

// Later these intensities will be normalised to the apical area cortical intensity and then thier variance will be plotted against time (this will be done using MATLAB).

//==========================================================================================================================================================================================================================================================================================================//

run("Close All");

// User Prompt
waitForUser("Open the file '..._xy_MIP' /or/ '..._orthogonal_MIP' \n from the cable analysis folder and then click 'OK'");

// Data organization
Path0 = getInfo("image.directory"); 
run("Set Measurements...", "area mean standard integrated kurtosis stack redirect=None decimal=3");
Stack.getDimensions(width, height, channels, slices, frames); totalslices = slices; totalframes = frames;

// Time interval is saved
Time_interval = Stack.getFrameInterval();
print("Time in seconds"+"\n"+ Time_interval);
selectWindow("Log"); saveAs("Text", Path0 +"time_interval" + ".txt"); run("Close"); 

// Getting the names for saving the final '.csv' files
imgname = getInfo("image.filename");
if (indexOf(imgname, "xy") != -1) {
	mean_intensity_array = "Mean_intensity_array_xy_MIP";
	total_intensity_array = "Total_intensity_array_xy_MIP";
	corres_roi_file = "1_3_xy_all_cables";
	whole_roi_file = "whole_area_measure_xy_MIP";
} else {
	mean_intensity_array = "Mean_intensity_array_orthogonal_MIP";
	total_intensity_array = "Total_intensity_array_orthogonal_MIP";	
	corres_roi_file = "1_6_orthogonal_all_cables";
	whole_roi_file = "whole_area_measure_orthogonal_MIP";
}

//==========================================================================================================================================================================================================================================================================================================//

// Image dimensions are obtained
getDisplayedArea(x, y, width, height);  imagewidth = width; imageheight = height;

//==========================================================================================================================================================================================================================================================================================================//

// Full ROI measure without any discretization
if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
}
roiManager("open", Path0 + corres_roi_file + ".zip");
setBatchMode(true);
for (t=1; t<=totalframes; t++) {
	for (n=1; n<=totalslices; n++) {
		roiManager("select", 0);
		Stack.setPosition(1, n, t);
		run("Measure");
		roiManager("delete");
	}	
}
selectWindow("Results"); saveAs("results", Path0 + whole_roi_file + ".csv"); close("Results");
setBatchMode(false);

//===================================================================================================================================//

// THEN WE SELECT ROI AND PERFORM DISCRETIZATION OF ROI

if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
}
roiManager("open", Path0 + corres_roi_file + ".zip");
Table.create("mean_int_list"); Table.create("total_int_list");
setBatchMode(true);
for (t=1; t<=totalframes; t++) {
	for (n=1; n<=totalslices; n++) {

		//===================================================================================================================================//
		
		// Third: we perform local discretizations (of 10 pixels x 10 pixels squares) all along the apical surface -        

        roiManager("select", 0); 
        Stack.setPosition(1, n, t); 
        mean_int_col_name = "mean_int_frame_" + t;
        total_int_col_name = "total_int_frame_" + t;
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
					roiManager("select", (Roicount-1)); roiManager("delete"); 
					Roicount=roiManager("count"); 
					roiManager("select", (Roicount-1)); roiManager("delete"); 
				}
			}			
		}
		selectWindow("Results"); get_mean_int = Table.getColumn("Mean"); get_total_int = Table.getColumn("RawIntDen"); run("Close");
		selectWindow("mean_int_list");
		Table.setColumn(mean_int_col_name, get_mean_int); Table.update;
		selectWindow("total_int_list");
		Table.setColumn(total_int_col_name, get_total_int); Table.update;
				
        //===================================================================================================================================//
        
		roiManager("select", 0); 
		roiManager("delete");		
	}	
}
setBatchMode(false);
selectWindow("mean_int_list"); Table.save(Path0 + mean_intensity_array +".csv"); run("Close");   
selectWindow("total_int_list"); Table.save(Path0 + total_intensity_array +".csv"); run("Close");   
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


