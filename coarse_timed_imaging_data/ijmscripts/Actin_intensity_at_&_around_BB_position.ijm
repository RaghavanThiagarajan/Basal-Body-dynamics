// Raghavan Thiagarajan, 2019, 15th April, DanStem, Copenhagen

// Analysis based on BasalBody positions obtained from the results exported from particle tracker plugin (which was used for tracking BasalBodies).
// First, the coordinates are used to spot the basalbodies and a ROI is obtained for each of the basalbody. For each of these ROI's, mean and total intensities are obtained.
// Then, using the ROI of basalbodies, an area of approximately 0.25 µm thickness surrounding the basalbody is selected. These surrounding regions are then
// registered as ROI and the mean & total intensities of this area is measured.

// If one needs to confirm if the ROI sizes used here are matching the size of the BBs, then this macro needs to be first run on the basalbody movie to verify if the ROI's are matching with the basalbodies. 
// If the sizes match BBs, then the script should be run on Actin movie to extract the actin intensities in the place of basalbodies and in the region surrounding the basalbodies.
// If the sizes dont match, then the proper values need to be replaced instead of 0.25 in the script below and then the script should be run on the Actin movie.
//==========================================================================================================================================================================================================================================================================================================//
run("Close All");

// User Prompt
waitForUser("Open the file 'Actin_gradient.tif' from the folder: \n  'Input_basalbody_tracks' and then click 'OK'");

Path0 = getInfo("image.directory");
Path = File.getParent(Path0);
dir0 = Path + "/data";
dir1 = dir0 + "/Actinint_at&around_basalbody_position/"; File.makeDirectory(dir1); 

//==========================================================================================================================================================================================================================================================================================================//

// Image dimensions are obtained
Stack.getDimensions(width, height, channels, slices, frames); totalslices = slices; totalframes = frames;
getDisplayedArea(x, y, width, height);  imagewidth = width; imageheight = height;
getPixelSize(unit, pixelWidth, pixelHeight);
getVoxelSize(width, height, depth, unit);
Time_interval = Stack.getFrameInterval();
print("Image"+"\t"+"Image"+"\t"+"Pixel"+"\t"+"Pixel"+"\t"+"Time"+"\t"+"Total"+"\t"+"Total"+"\t"+"Voxel"+"\n"+"width"+"\t"+"height"+"\t"+"width"+"\t"+"height"+"\t"+"Interval"+"\t"+"frames"+"\t"+"slices"+"\t"+"depth"+"\n"+ imagewidth+"\t"+ imageheight+"\t"+pixelWidth+"\t"+pixelHeight+"\t"+Time_interval+"\t"+totalframes+"\t"+totalslices+"\t"+depth);
selectWindow("Log"); saveAs("Text", dir1 +"Image_dimensions" + ".txt"); run("Close"); 

setOption("ExpandableArrays", true);
id = getImageID();
Stack.getDimensions(width, height, channels, slices, frames); totalslices = slices; totalframes = frames;
if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
}
run("Set Measurements...", "area mean perimeter integrated stack redirect=None decimal=3");

//==========================================================================================================================================================================================================================================================================================================//

// Fetching the results obtained from Particle tracker plugin.
open(Path0+"Table_based_on_trajectories.csv");
Trajectory_elements = getValue("results.count"); 
Total_trajectories = Table.get("Trajectory", (Trajectory_elements-1)); 
Frame_no = newArray; xcoord = newArray; ycoord = newArray; Trajectory = newArray;
Area_BBposition = newArray; Perim_BBposition = newArray; MeanInt_BBposition = newArray; TotalInt_BBposition = newArray; 
Area_BBsurround = newArray; Perim_BBsurround = newArray; MeanInt_BBsurround = newArray; TotalInt_BBsurround = newArray;


// Getting the ROI of basalbodies from the coordinates obtained from the tracking using particle tracker plugin.
var counter; increment = 0;
for (I = 0; I <= (Trajectory_elements-1); I++) {
	selectWindow("Table_based_on_trajectories.csv");
	Current_trajectoryno = Table.get("Trajectory", I);
	Trajectory[I] = Table.get("Trajectory", I);	
	Frame = Table.get("Frame", I);
	Frame_no[I] = 1 + Frame;
	// xcoord[I] = Table.get("x", I);
	// ycoord[I] = Table.get("y", I);	
	xcrd = Table.get("x", I); // Uncomment and use these lines if you want to position the ROIs exactly on the basal bodies
	xcoord[I] = Math.floor(xcrd);
	ycrd = Table.get("y", I);
	ycoord[I] = Math.floor(ycrd);	

	// loop_counter(); // Calling the function for loop counter.
	counter = increment + 1; // Counting the number of loops run
	increment = counter; // print("I="+I+";","counter="+counter);
	
	if (I == (Trajectory_elements-1)) {
		Next_trajectoryno = Current_trajectoryno + 1;			
	}
	else {
		Next_trajectoryno = Table.get("Trajectory", I+1);
	}
	if (Current_trajectoryno != Next_trajectoryno) {
		tot_steps = counter; // print("tot_steps="+tot_steps);
		initial_step = I - (tot_steps-1); // print("intital_step="+initial_step);
		selectImage(id);
		for (f = 0; f <= tot_steps-1; f++) {
			selectWindow("Table_based_on_trajectories.csv");
			t_frame = Table.get("Frame", initial_step+f); // print("t_frame="+t_frame); print("initial_step+f="+initial_step+f);
			Stack.setPosition(1, 1, t_frame+1);
			makePoint(xcoord[initial_step+f], ycoord[initial_step+f], "tiny circle");
			run("Enlarge...", "enlarge=0.25"); // The size of BB is roughly 0.5 micron in diameter. Here a tiny dot is enlarged to become a circle of radius 0.25 µm. In other words, the diameter of this circle is around 0.5 µm which will cover the entire BB.
			roiManager("add");
			run("Measure"); 
			Area_BBposition[initial_step+f] = getResult("Area", nResults-1); Perim_BBposition[initial_step+f] = getResult("Perim.", nResults-1); 
			MeanInt_BBposition[initial_step+f] = getResult("Mean", nResults-1); TotalInt_BBposition[initial_step+f] = getResult("RawIntDen", nResults-1); 
		}
		increment = 0;
	}
}
selectWindow("Table_based_on_trajectories.csv"); run("Close");
selectWindow("Results"); close("Results");
selectWindow("ROI Manager"); roiManager("save", dir1 +"ROI_BasalBody_segmentation_&_tracks" + ".zip"); run("Close");

//==========================================================================================================================================================================================================================================================================================================//

// Selecting the area surrounding the basalbodies and getting their intensities.
roiManager("open", dir1 +"ROI_BasalBody_segmentation_&_tracks" + ".zip");
ROI_count = roiManager("count");
setBatchMode(true);
for (t = 0; t <= ROI_count-1; t++) {
	roiManager("select", 0); 
	run("Enlarge...", "enlarge=0.25"); // The size of BB is roughly 0.5 micron in diameter. The enlargement here gets the area surrounding the BBs. To do son, the already drawn circle of radius 0.25 µm in the previous section is again enlarged by 0.25 µm. 
	// In other words, a circle of 0.5 µm radius is drawn and the donut area between the smaller and larger circle is obtained.
	selectImage(id);
	roiManager("add"); ROIcount = roiManager("count");  
	roiManager("select", newArray(0,(ROIcount-1)));
	roiManager("xor"); 
	run("Measure"); 
	Area_BBsurround[t] = getResult("Area", nResults-1); Perim_BBsurround[t] = getResult("Perim.", nResults-1); 
	MeanInt_BBsurround[t] = getResult("Mean", nResults-1); TotalInt_BBsurround[t] = getResult("RawIntDen", nResults-1);
	roiManager("add"); ROIcount = roiManager("count"); 
	roiManager("select", newArray(0,(ROIcount-2)));
	roiManager("delete"); 
}
setBatchMode(false);	
selectWindow("ROI Manager"); roiManager("save", dir1 +"ROI_BasalBody_enlarged" + ".zip"); run("Close");
selectWindow("Results"); close("Results");
Table.showArrays("Actin_intensity_at_&_around_BB_position", Trajectory, Frame_no, xcoord, ycoord, MeanInt_BBposition, TotalInt_BBposition, MeanInt_BBsurround, TotalInt_BBsurround, Area_BBposition, Perim_BBposition, Area_BBsurround, Perim_BBsurround);
selectWindow("Actin_intensity_at_&_around_BB_position"); Table.save(dir1 + "Actin_intensity_at_&_around_BB_position" + ".csv"); run("Close");

//==========================================================================================================================================================================================================================================================================================================//

/*
// Function for counting the number of loops run by the for loop.
function loop_counter() {
	counter = increment + 1;
	return counter;
}
*/
