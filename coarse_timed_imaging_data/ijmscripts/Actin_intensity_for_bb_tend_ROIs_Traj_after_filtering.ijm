// Raghavan Thiagarajan, 2019, 18th June, DanStem, Copenhagen

// In this script, we use the already obtained tend positions / final positions of all trajectories from the Matlab analysis to get the actin intensity in these positions. 
// The matlab script "tend_time_dist_spatial_plot_Traj_after_filtering.m" gives "TrajecInitPos.csv" where all the final BB position details are stored. In this script, we use 
// these positions to get the mean intensity values of actin from the Actin movie (Actin_gradient.tif), in the corresponding tend positions of BB trajectories. Only those trajectories 
// that are longer than a particular duration are used for the analysis. This is stored in the "value_for_filter.txt" in the folder: "/Input_basalbody_tracks/automated_tracking/". 
// For more explanation on why such duration was chosen, look at the first section of "Gradients_BB_int_normalization_by_cortex_Traj_after_filtering.m" matlab script.
// This script works in the following manner: first, the coordinates are used to spot the basalbodies and a ROI of tiny circle is obtained for each basalbody. Then, using the 
// coordinates of basalbodies, a circle of area (0.25 µm diameter) is drawn. Then for each of these ROI's, mean actin intensity is obtained. Normalisation of these intensities
// by the corresponding apical domain mean actin intensity is done in the matlab script.
//==========================================================================================================================================================================================================================================================================================================//
run("Close All");

// User prompt
waitForUser("Open the files 'Actin_gradient.tif' from the \n  folder: 'Input_Actin' and then click 'OK'");

Path0 = getInfo("image.directory");
Path = File.getParent(Path0);
dir_00 = Path + "/Plots"; 

// getting the duration for the trajectory length to be filtered from the value_for_filter.txt file.
dir2 = Path + "/Input_basalbody_tracks/automated_tracking/value_for_filter.txt";
str = File.openAsString(dir2);
lines=split(str,"\n"); // Array.print(lines);
extract_traj_duration_string = lines[4]; // print(extract_traj_duration_string);
extract_traj_duration_integer = parseInt(extract_traj_duration_string); //extract_traj_duration_integer = extract_traj_duration_integer + 10; //print(extract_traj_duration_integer);

folder_name = "tend_basalbody_position_" + extract_traj_duration_integer + "minlongTraj";
dir_0 = dir_00 + "/"+folder_name+"";
dir0 = dir_0 + "/bb_tend_ROIs_data/"; File.makeDirectory(dir0); 

//==========================================================================================================================================================================================================================================================================================================//

// Image dimensions are obtained
Stack.getDimensions(width, height, channels, slices, frames); totalslices = slices; totalframes = frames;
getDisplayedArea(x, y, width, height);  imagewidth = width; imageheight = height;
getPixelSize(unit, pixelWidth, pixelHeight);
getVoxelSize(width, height, depth, unit);
Time_interval = Stack.getFrameInterval();
print("Image"+"\t"+"Image"+"\t"+"Pixel"+"\t"+"Pixel"+"\t"+"Time"+"\t"+"Total"+"\t"+"Total"+"\t"+"Voxel"+"\n"+"width"+"\t"+"height"+"\t"+"width"+"\t"+"height"+"\t"+"Interval"+"\t"+"frames"+"\t"+"slices"+"\t"+"depth"+"\n"+ imagewidth+"\t"+ imageheight+"\t"+pixelWidth+"\t"+pixelHeight+"\t"+Time_interval+"\t"+totalframes+"\t"+totalslices+"\t"+depth);
selectWindow("Log"); saveAs("Text", dir0 +"Image_dimensions" + ".txt"); run("Close"); 

setOption("ExpandableArrays", true);
id = getImageID();
Stack.getDimensions(width, height, channels, slices, frames); totalslices = slices; totalframes = frames;
if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
}
run("Set Measurements...", "area mean perimeter integrated stack redirect=None decimal=3");

//==========================================================================================================================================================================================================================================================================================================//

// Fetching the results obtained from the .csv file from the matlab script.
open(dir_0+"/TrajecendPos.csv");
Trajectory_elements = getValue("results.count"); 
Total_trajectories = Table.get("Trajectory", (Trajectory_elements-1)); 
Trajectory_no = newArray; Frame_tend = newArray; xcoord = newArray; ycoord = newArray; MeanInt_BBposition = newArray; 
MeanInt_SurrBBposition = newArray; xcoord_surr = newArray; ycoord_surr = newArray; Frame_tend_surr = newArray; Trajectory_no_surr = newArray;

// Getting the ROI of basalbodies from the coordinates obtained from the tracking using particle tracker plugin.
// This for loop gets the ROI at the position of the BBs
var counter; increment = 0;
for (I = 0; I <= (Trajectory_elements-1); I++) {
	selectWindow("TrajecendPos.csv");
	Current_trajectoryno = Table.get("C1", I);
	Fram = Table.get("C2", I);
	xcord = Table.get("C3", I);
	ycord = Table.get("C4", I);	

	Stack.setPosition(1, 1, 1);
	makePoint(xcord, ycord, "tiny circle");
	run("Enlarge...", "enlarge=0.25"); // The size of BB is roughly 0.5 micron in diameter. Here a tiny dot is enlarged to become a circle of radius 0.25 µm. In other words, the diameter of this circle is around 0.5 µm which will cover the entire BB.
	roiManager("add");

	for (f = 0; f <= totalframes-1; f++) {
		roiManager("select", I); 
		tt = f + 1;
		Stack.setPosition(1, 1, tt);
		run("Measure");
		MeanInt_BBposition[increment+f] = getResult("Mean", nResults-1);
		xcoord[increment+f] = xcord;
		ycoord[increment+f] = ycord;
		Frame_tend[increment+f] = Fram;
		Trajectory_no[increment+f] = Current_trajectoryno;
	}
	increment = increment+totalframes;
}
selectWindow("Results"); close("Results");
selectWindow("ROI Manager"); roiManager("save", dir0 +"Actin_intensity_at_bb_tend_ROIs" + ".zip"); run("Close");

// This for loop gets the ROI in the surrounding position of the BBs
var counter; increment = 0;
for (I = 0; I <= (Trajectory_elements-1); I++) {
	selectWindow("TrajecendPos.csv");
	Current_trajectoryno = Table.get("C1", I);
	Fram = Table.get("C2", I);
	xcord = Table.get("C3", I);
	ycord = Table.get("C4", I);	

	Stack.setPosition(1, 1, 1);
	makePoint(xcord, ycord, "tiny circle");
	run("Enlarge...", "enlarge=0.25"); // The size of BB is roughly 0.5 micron in diameter. Here a tiny dot is enlarged to become a circle of radius 0.25 µm. In other words, the diameter of this circle is around 0.5 µm which will cover the entire BB.
	roiManager("add");
	run("Enlarge...", "enlarge=0.25");
	roiManager("add");
	cnt = roiManager("count");
	roiManager("select", newArray((cnt-1),(cnt-2)));
	roiManager("xor"); 
	roiManager("add"); cnt = roiManager("count");
	roiManager("select", newArray((cnt-2),(cnt-3)));
	roiManager("delete"); 

	for (f = 0; f <= totalframes-1; f++) {
		roiManager("select", I); 
		tt = f + 1;
		Stack.setPosition(1, 1, tt);
		run("Measure");
		MeanInt_SurrBBposition[increment+f] = getResult("Mean", nResults-1);
		xcoord_surr[increment+f] = xcord;
		ycoord_surr[increment+f] = ycord;
		Frame_tend_surr[increment+f] = Fram;
		Trajectory_no_surr[increment+f] = Current_trajectoryno;
	}
	increment = increment+totalframes;
}
selectWindow("Results"); close("Results");
selectWindow("ROI Manager"); roiManager("save", dir0 +"Actin_intensity_Surr_bb_tend_ROIs" + ".zip"); run("Close");
selectWindow("TrajecendPos.csv"); run("Close");
// Use the command below for sanity checking / trouble shooting
//Table.showArrays("Actin_intensity_at_&_surr_bb_tend_ROIs", Trajectory_no, Trajectory_no_surr, Frame_tend, Frame_tend_surr, xcoord, xcoord_surr, ycoord, ycoord_surr, MeanInt_BBposition, MeanInt_SurrBBposition); 
Table.showArrays("Actin_intensity_at_&_surr_bb_tend_ROIs", Trajectory_no, Frame_tend, xcoord, ycoord, MeanInt_BBposition, MeanInt_SurrBBposition); 
selectWindow("Actin_intensity_at_&_surr_bb_tend_ROIs"); Table.save(dir0 + "ActInt_at&sur_BBtend_ROIs" + ".csv"); run("Close");






