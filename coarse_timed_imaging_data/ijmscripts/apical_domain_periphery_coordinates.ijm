
run("Close All");

// User Prompt
waitForUser("Open the file 'Actin_gradient.tif' from the folder: \n  'Input_Actin' and then click 'OK'");

Path0 = getInfo("image.directory"); 
id = getImageID();

Path1 = File.getParent(Path0); 
dir1 = Path1 + "/data/";

for (jj = 1; jj <= 2; jj++) {
	
	if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
     }
     
     if (jj == 1) {
     	roiManager("open", Path0 +"RoiSet_actin_thresholded" + ".zip");
     	filesavename = "Apical_domain_periphery_cords_with_cortex";
     } else {
     	roiManager("open", Path0 +"ROI_for_gradient_measurements" + ".zip");
     	filesavename = "Apical_domain_periphery_cords_without_cortex";
     }
     
     ROI_count = roiManager("count");
     setBatchMode(true);
     Table.create("coordinates");
     for (i=1; i<=ROI_count; i++) {
     	roiManager("select", i-1); // setSlice(i);  	
     	Roi.getCoordinates(xpoints, ypoints);	
     	//getSelectionCoordinates(xpoints, ypoints);
     	col_x = "x_cord" + "_"+ i;
     	col_y = "y_cord" + "_"+ i;
     	Table.setColumn(col_x, xpoints);
     	Table.setColumn(col_y, ypoints);	
     }
     setBatchMode(false);
     Table.save(dir1 + filesavename + ".csv"); run("Close"); 
     selectWindow("ROI Manager"); run("Close");     
}

selectImage(id); run("Close"); 


