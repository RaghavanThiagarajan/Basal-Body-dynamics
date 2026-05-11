// Raghavan Thiagarajan, 17th April 2023, reNEW, Copenhagen

// This script is used to obtain the information on where the new BBs are appearing within the apical domain. This script should be run when prompted by matlab while running "bb_appearance_distance.m"

// In detail, the idea (from Mandar Inamdar, IIT Bombay) is the following. We first find out all those frames where new BBs are appearing. Along with this information, we also
// obtain how many BBs are appearing in each of these frames and the coordinates of all the BBs. This is obtained using the matlab script "bb_appearance_distance.m" and these
// details are stored in the file "Newly_appearing_BB_coordinates.csv" in the "data" folder. Previously we had obtained the contours of apical domain area for every frame which
// stored as ROI file in "Input Actin" folder as "RoiSet_actin_thresholded.zip". 

// Now the idea is to go to every frame (where BBs appear) and get two informations: (1) ratio of all area contours in the previous frame to the contour of the current frame (where
// the new BBs have appeared), which we call as "area fraction"; (2) find out the number of BBs that are appearing within the donut / annulus of the area contours, which we call as "BB in 
// coresponding area fraction". For example, suppose we have 6 new BBs appearing in Frame 5 and that these BBs are appearing in the following regions: 2 BBs within area contour 1 (A1), 
// 1 BB in-between area contours 1 and 2 (A2 & A3), 3 BBs in-between area contours 3 and 4 (A3 & A4), then the "area fractions" and the corresponding "BB in corresponding area fractions" will be:
// Area fractions:                     (A1/A5), (A2/A5), (A3/A5), (A4/A5), (A5/A5)
// BB in corresponding area fractions:   2,        0,       1,       3,       0
// We will will obtain this information for all frames from frame 1 to last frame. Therefore, as the frame numbers increase, the data points in ("Area fractions" and "BB in corresponding area fractions") will
// also increase. Open the files ("Area_fraction_table.csv" & "BB_in_area_fraction_table.csv") saved from this script for better understanding. Also, the last area fraction for all frames will
// be "1". Look at the last fraction in the above example (A5/A5). This corresponds to the newest region appeared during the apical expansion. And we are getting the corresponding number of BBs 
// for each donut / annulus of subsequent area contours. After getting this data for all the frames in the cell, we will bin the data points based on "Area fraction" and plot "Area fraction" 
// bins in the x axis and the corresponding bins from "BBs in corresponding area fraction" in the y axis. This plotting is done by the last section of matlab script "bb_appearance_distance.m". 
// In this plot, if we see more number of BBs appearing towards "1" then we we can claim that newer BBs are appearing in the newer regions. On the other hand if we seem more number of BBs 
// appearing towards "0" or the "lowest value" in the plot, then we can claim that the newer BBs are appearing in the center. If we see more number of BBs appearing in a particular area fraction, 
// then we know the favorite spot of BB appearance. This is the idea. 

// The whole process is split into two sections: first section is executed in Fiji using this script and the second section is executed using the matlab script "bb_appearance_distance.m". As part
// of first section, in this Fiji script, we obtain the "Area fraction" values and the "BB in corresponding area fractions" values for all frames. Look at the files: "Area_fraction_table.csv" & 
// "BB_in_area_fraction_table.csv". Then the plotting is done using matlab in the script "bb_appearance_distance.m". 

//==========================================================================================================================================================================================================================================================================================================//
run("Close All");

// User prompt
waitForUser("Open the files 'Actin_gradient.tif' from the \n  folder: 'Input_Actin' and then click 'OK'");

// Open the image stack "Actin gradient" from the "Input Actin" folder
id = getImageID();
selectImage(id);

// creating all directories
Path0 = getInfo("image.directory"); 
Path1 = File.getParent(Path0); 
dir1 = Path1 + "/data/";

// opening ROI manager
if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
}
roiManager("open", Path0 +"RoiSet_actin_thresholded" + ".zip");

// Opening previously obtained .csv file
open(dir1+"Newly_appearing_BB_coordinates.csv"); selectWindow("Newly_appearing_BB_coordinates.csv");
no_of_elmts = getValue("results.count"); 

// creating all the necessary arrays
setOption("ExpandableArrays", true);
area_fraction = newArray; bb_in_area_fraction = newArray; 
bb_x = newArray; bb_y = newArray;

// creating the tables
Table.create("Area_fraction_table");
Table.create("BB_in_area_fraction_table");

// In the section below, we go through every frame in the "Newly_appearing_BB_coordinates.csv" file and obtain the corresponding "Area fraction" & "BB in corresponding area fractions"

// the first loop goes through ever frame in the "Newly_appearing_BB_coordinates.csv" file
setBatchMode(true);
for (i = 0; i < no_of_elmts; i++) {
	selectWindow("Newly_appearing_BB_coordinates.csv");
	frame_no = Table.get("Frame_no_of_BB_appearance", i); 
	no_of_bb = Table.get("No_of_newly_appearing_BBs", i); 
	// getting the area of the apical domain contour in the current frame - we call this as base area.
	selectImage(id);
	roiManager("select", frame_no-1);
	run("Measure");
	base_area = getResult("Area", 0); 
	close("Results");
	// the for loop below goes through all the BB coordinates for the current frame and makes an array of x and y coordinates	
	for (l = 1; l <= no_of_bb; l++) {
		bb_x_column = "Xcrd_BB_" + l;
		bb_y_column = "Ycrd_BB_" + l;
		selectWindow("Newly_appearing_BB_coordinates.csv");
		bb_x[l-1] = Table.get(bb_x_column, i);
		bb_y[l-1] = Table.get(bb_y_column, i);		
	}
	// the for loop below goes through all the area contours of the previous frames and gets: (1) area fractions; (2) the donuts between the subsequent area contours
	for (j = 1; j <= frame_no; j++) {
		area_concat = "Frame_" + frame_no; // name of the columns in the table that will be constructed down the script
		// getting the area fractions between all previous areas and the current base area.
		selectImage(id);
		roiManager("select", j-1);
		run("Measure");
		area_temp = getResult("Area", 0); 
		close("Results");
		area_fraction[j-1] = area_temp / base_area; // array that contains all the area fractions for this particular frame
		// getting the donuts between the subsequent area contours		
		if (j == 1) {
			roiManager("select", j-1);			
		}
		else {
			roiManager("select", newArray(j-2, j-1));			
			roiManager("xor"); 
		}
		roiManager("add"); ROIcount = roiManager("count"); 	// adding the donut to the roi manager
		// the below logic checks the localisation of all BB coordinates in the current frame
		// I.e. it finds which BB corresonds to which donut
		if (bb_x.length  == 0) {
			inside_temp = 0;			
		}
		else {
			// in the for loop below, we go through the arrays of x and y coordinates of BBs (created above) and check
			// which BB localises to which donut
			inside_temp = 0;	
			for (k = 1; k <= bb_x.length; k++) {	
				roiManager("select", ROIcount-1);				
				if (Roi.contains(bb_x[k-1], bb_y[k-1])) {
					inside_temp = inside_temp + 1; // this variable contains the number of BBs for every area fraction
					bb_x = Array.deleteIndex(bb_x, k-1);
					bb_y = Array.deleteIndex(bb_y, k-1);	
					k = 0;
				}				
			}                  			
		}
		roiManager("select", ROIcount-1); // deleting the donut roi from the roi manager
		roiManager("delete"); 
		bb_concat = "Frame_" + frame_no; // name of the columns in the table that will be constructed down the script
		bb_in_area_fraction[j-1] = inside_temp; // array that contains the number of BB for the corresponding Area fractions for this particular frame
	}
	// below we concatenate all the arrays to their corresponding tables
	selectWindow("Area_fraction_table");	
	Table.setColumn(area_concat, area_fraction);
	selectWindow("BB_in_area_fraction_table");	
	Table.setColumn(bb_concat, bb_in_area_fraction);		
}
setBatchMode(false);
// Saving the tables in .csv format
selectWindow("Area_fraction_table"); Table.save(dir1 + "Area_fraction" + ".csv"); run("Close");
selectWindow("BB_in_area_fraction_table"); Table.save(dir1 + "BB_in_area_fraction" + ".csv"); run("Close");
selectWindow("Newly_appearing_BB_coordinates.csv"); run("Close");
selectWindow("ROI Manager"); run("Close");






