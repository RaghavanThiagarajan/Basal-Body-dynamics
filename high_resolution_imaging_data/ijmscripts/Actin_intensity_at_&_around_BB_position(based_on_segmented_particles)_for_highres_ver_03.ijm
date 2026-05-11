// Raghavan Thiagarajan, 2019, 15th April, DanStem, Copenhagen
// Modified on 2021, 21st May, DanStem, Copenhagen
// this modification allows the script to be run on high-res images of actin mesh (actin/BB). In this case, there is only one image and not a stack.
// the modified script works with a different .csv file (Table_based_on_segmented_particles) than the original one. Also it fetches the intensities from 
// the combined ROIs of all BBs and in the area outside the BBs.

// Analysis based on BasalBody positions obtained from the results exported from particle tracker plugin (which was used for tracking BasalBodies).
// First, the coordinates are used to spot the basalbodies and a ROI is obtained for each of the basalbody. For each of these ROI's, mean and total intensities are obtained.
// Then, using the ROI of basalbodies, an area of approximately 5 pixel thickness surrounding the basalbody is selected. These surrounding regions are then
// registered as ROI and the mean & total intensities of this area is measured.

// This macro needs to be first run on the basalbody movie, verified if the ROI's are matching with the basalbodies and then should be run on Actin movie to extract the actin 
// intensities in the place of basalbodies and in the region surrounding the basalbodies.
//==========================================================================================================================================================================================================================================================================================================//

Path0 = getInfo("image.directory");
Path = File.getParent(Path0);
dir0 = Path + "/data";
dir1 = dir0 + "/Actinint_at&around_basalbody_position/"; File.makeDirectory(dir1); 
dir2 = dir0 + "/Gradients_of_actin_intensity/";

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
open(Path0+"Table_based_on_segmented_particles.csv");
Trajectory_elements = getValue("results.count"); 
Frame_no = newArray; xcoord = newArray; ycoord = newArray; Trajectory = newArray;
Area_BBposition = newArray; Perim_BBposition = newArray; MeanInt_BBposition = newArray; TotalInt_BBposition = newArray; 
Area_BBsurround = newArray; Perim_BBsurround = newArray; MeanInt_BBsurround = newArray; TotalInt_BBsurround = newArray;

// Getting the ROI of basalbodies from the coordinates obtained from the tracking using particle tracker plugin.

for (I = 0; I <= (Trajectory_elements-1); I++) {
	selectWindow("Table_based_on_segmented_particles.csv");
	Trajectory[I] = 1 + I;	// since there are no trajectories, each basalbody is counted as a trajectory where each trajectory willl have only one time point - 
	// meaning they are not real trajectories but virtual trajectories with one time point.
	Frameno = Table.get("Frame", I);
	Frame_no[I] = 1 + Frameno; //Array.show(Frame_no);
	// xcoord[I] = Table.get("x", I);
	// ycoord[I] = Table.get("y", I);	
	xcrd = Table.get("x", I); // Uncomment and use these lines if you want to position the ROIs exactly on the basal bodies
	xcoord[I] = Math.floor(xcrd);
	ycrd = Table.get("y", I);
	ycoord[I] = Math.floor(ycrd);	
	
	selectImage(id);
	selectWindow("Table_based_on_segmented_particles.csv");
	Stack.setPosition(1, 1, 1);
	makePoint(xcoord[I], ycoord[I], "tiny circle");
	run("Enlarge...", "enlarge=0.25"); // The size of BB is roughly 0.5 micron in diameter. Here a tiny dot is enlarged to become a circle of radius 0.25 µm. In other words, the diameter of this circle is around 0.5 µm which will cover the entire BB.
	roiManager("add");
	run("Measure"); 
	Area_BBposition[I] = getResult("Area", nResults-1); Perim_BBposition[I] = getResult("Perim.", nResults-1); 
	MeanInt_BBposition[I] = getResult("Mean", nResults-1); TotalInt_BBposition[I] = getResult("RawIntDen", nResults-1); 
}
selectWindow("Table_based_on_segmented_particles.csv"); run("Close");
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

// Selecting: (1) all BBs together; and (2) the space outside the BBs but within the cortex (used for getting the actin intensity)
// This is done by (1) combining all the BBs; and (2) XOR of all BBs and the cortex ROI.

run("Set Measurements...", "area mean perimeter integrated stack display redirect=None decimal=3");
open(dir1 + "ROI_BasalBody_segmentation_&_tracks.zip");

open(dir2+"ROI_gradient_of_actin_intensity.roi");
roiManager("add");
roiManager("deselect");
roiManager("xor");
roiManager("add");
ROIcount = roiManager("count");
roiManager("select", (ROIcount-1)); 
roiManager("rename", "area_excluding_Rois");

rois_to_be_selected = Array.getSequence(ROIcount-3);
roiManager("select", rois_to_be_selected);
roiManager("combine");
roiManager("add");
ROIcount = roiManager("count");
roiManager("select", (ROIcount-1)); 
roiManager("rename", "all_ROIs");

ROIcount = roiManager("count");
roiManager("select", (ROIcount-3));
roiManager("delete");

ROIcount = roiManager("count");
roiManager("select", newArray((ROIcount-2), (ROIcount-1)));
roiManager("save selected", dir1 +"ROI_BB_&_outside_BB" + ".zip");

roiManager("select", (ROIcount-2)); run("Measure"); 
roiManager("select", (ROIcount-1)); run("Measure"); 
Roi.remove;
selectWindow("ROI Manager"); run("Close");

selectWindow("Results"); 
saveAs("results", dir1 +"BB_&_outside_BB_msmts" + ".csv"); 
close("Results");


//==========================================================================================================================================================================================================================================================================================================//


/*
// Function for counting the number of loops run by the for loop.
function loop_counter() {
	counter = increment + 1;
	return counter;
}
*/
