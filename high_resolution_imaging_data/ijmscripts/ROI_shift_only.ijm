// Raghavan Thiagarajan, 2019, 2nd April, DanStem, Copenhagen. 
// This script changes the ROI size over a hyperstack.

Dialog.create("How should the ROI change ?");
Dialog.addCheckbox("Increase", false);
Dialog.addCheckbox("Decrease", true);
Dialog.addNumber("Shift value [in µm]:", 000);
Dialog.show;
ROI_shift_value = Dialog.getNumber();
Increase = Dialog.getCheckbox();
if (Increase==false) ROI_shift_value = ROI_shift_value * (-1); 

Path = getInfo("image.directory"); 
// dir0 = Path+"/Analysis_results/"; File.makeDirectory(dir0); 
id = getImageID();
Stack.getDimensions(width, height, channels, slices, frames); totalslices = slices; totalframes = frames;
// totalframes = 68;
// totalslices = 3;
setOption("ExpandableArrays", true);

if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
}

// Changing the ROI size
roiManager("open", Path +"RoiSet_actin_thresholded" + ".roi");
ROI_count = roiManager("count");
setBatchMode(true);
for (rr=1; rr<=ROI_count; rr++) {
		roiManager("select", rr-1);
		run("Enlarge...", "enlarge=ROI_shift_value"); // Shift in micrometers. 1px = 0.06844 um.
        roiManager("update");
}
selectWindow("ROI Manager"); roiManager("save", Path +"ROI_for_gradient_measurements" + ".roi"); run("Close");
setBatchMode(false);		

