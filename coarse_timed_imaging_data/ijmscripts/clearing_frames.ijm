// Raghavan Thiagarajan, reNEW, Copenhagen, 16th January 2024

// This script is part of the BB analysis pipeline
// This script saves the Actin_gradient.tif stack as image sequence in different folders 
// so that these images can be used for plotting the BB appearance and BB disappearance

run("Close All");

// User prompt
waitForUser("Open the files 'Actin_gradient.tif' from the \n  folder: 'Input_Actin' and then click 'OK'");

id = getImageID();
Path0 = getInfo("image.directory");
Path = File.getParent(Path0);
dir_00 = Path + "/Plots"; 

// getting the duration for the trajectory length to be filtered from the value_for_filter.txt file.
dir2 = Path + "/Input_basalbody_tracks/automated_tracking/value_for_filter.txt";
str = File.openAsString(dir2);
lines=split(str,"\n"); // Array.print(lines);
extract_traj_duration_string = lines[4]; // print(extract_traj_duration_string);
extract_traj_duration_integer = parseInt(extract_traj_duration_string); //extract_traj_duration_integer = extract_traj_duration_integer + 10; //print(extract_traj_duration_integer);

// getting duplicate for the stack
selectImage(id); run("Duplicate...", "duplicate");
selectImage(id); run("Close");

// clearing the frames
selectImage("Actin_gradient-1.tif");
run("Select All");
setBackgroundColor(0, 0, 0);
run("Clear", "stack");

// saving for t0 (traj_duration)
folder_name = "t0_basalbody_position_" + extract_traj_duration_integer + "minlongTraj";
dir_0 = dir_00 + "/"+folder_name+"";
dir1 = dir_0 + "/bb_appearance_input/"; // print(dir1);
selectImage("Actin_gradient-1.tif");
run("Image Sequence... ", "select="+dir1+" dir="+dir1+" format=TIFF name=bb_ start=1 digits=3");

// saving for tend (traj_duration)
folder_name = "tend_basalbody_position_" + extract_traj_duration_integer + "minlongTraj";
dir_0 = dir_00 + "/"+folder_name+"";
dir2 = dir_0 + "/bb_disappearance_input/"; // print(dir2);
selectImage("Actin_gradient-1.tif");
run("Image Sequence... ", "select="+dir2+" dir="+dir2+" format=TIFF name=bb_ start=1 digits=3");

// saving for t0 all frames
dir_0 = dir_00 + "/t0_basalbody_position_all";
dir3 = dir_0 + "/bb_appearance_input/"; // print(dir3);
selectImage("Actin_gradient-1.tif");
run("Image Sequence... ", "select="+dir3+" dir="+dir3+" format=TIFF name=bb_ start=1 digits=3");

// saving for tend all frames
dir_0 = dir_00 + "/tend_basalbody_position_all";
dir4 = dir_0 + "/bb_disappearance_input/"; // print(dir4);
selectImage("Actin_gradient-1.tif");
run("Image Sequence... ", "select="+dir4+" dir="+dir4+" format=TIFF name=bb_ start=1 digits=3");

selectImage("Actin_gradient-1.tif"); run("Close");



