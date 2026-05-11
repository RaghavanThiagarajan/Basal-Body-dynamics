// Raghavan Thiagarajan, reNEW Copenhagen, July 2024

run("Close All");
// User Prompt
waitForUser("Open the file 'Actin_gradient.tif' from the folder: \n  'Input_Actin' and then click 'OK'");

Path00 = getInfo("image.directory");
Path0 = File.getParent(Path00);
Path = Path0 + "/Plots/bb_density_distribution_expansion_bias/";

selectWindow("Actin_gradient.tif"); run("Close");

open_save_tif_files("area_bb_topbottom_half");
open_save_tif_files("area_bb_leftright_half");
open_save_tif_files("area_bb_quad");
open_save_tif_files("bb_density_topbottom_half");
open_save_tif_files("bb_density_leftright_half");
open_save_tif_files("bb_density_quad");
open_save_tif_files("actin_meanint_topbottom_half");
open_save_tif_files("actin_meanint_leftright_half");
open_save_tif_files("actin_meanint_quad");
open_save_tif_files("actin_totalint_topbottom_half");
open_save_tif_files("actin_totalint_leftright_half");
open_save_tif_files("actin_totalint_quad");

open(Path + "area_bb_topbottom_half.tif");
open(Path + "area_bb_leftright_half.tif");
run("Combine...", "stack1=area_bb_topbottom_half.tif stack2=area_bb_leftright_half.tif");
open(Path + "area_bb_quad.tif");
run("Combine...", "stack1=[Combined Stacks] stack2=area_bb_quad.tif");
selectWindow("Combined Stacks"); rename("1");
open(Path + "bb_density_topbottom_half.tif");
open(Path + "bb_density_leftright_half.tif");
run("Combine...", "stack1=bb_density_topbottom_half.tif stack2=bb_density_leftright_half.tif");
open(Path + "bb_density_quad.tif");
run("Combine...", "stack1=[Combined Stacks] stack2=bb_density_quad.tif");
selectWindow("Combined Stacks"); rename("2");
open(Path + "actin_meanint_topbottom_half.tif");
open(Path + "actin_meanint_leftright_half.tif");
run("Combine...", "stack1=actin_meanint_topbottom_half.tif stack2=actin_meanint_leftright_half.tif");
open(Path + "actin_meanint_quad.tif");
run("Combine...", "stack1=[Combined Stacks] stack2=actin_meanint_quad.tif");
selectWindow("Combined Stacks"); rename("3");
open(Path + "actin_totalint_topbottom_half.tif");
open(Path + "actin_totalint_leftright_half.tif");
run("Combine...", "stack1=actin_totalint_topbottom_half.tif stack2=actin_totalint_leftright_half.tif");
open(Path + "actin_totalint_quad.tif");
run("Combine...", "stack1=[Combined Stacks] stack2=actin_totalint_quad.tif");
selectWindow("Combined Stacks"); rename("4");

run("Combine...", "stack1=1 stack2=2 combine");
run("Combine...", "stack1=[Combined Stacks] stack2=3 combine");
run("Combine...", "stack1=[Combined Stacks] stack2=4 combine");
selectWindow("Combined Stacks");
saveAs("tiff", Path + "all_combined" + ".tif"); 
run("Close All");

//------------------------------------------------//

function open_save_tif_files(folder_name) {
	
	File.openSequence(Path + "/" + folder_name); 
	saveAs("Tiff", Path + folder_name + ".tif");
	selectWindow(folder_name + ".tif"); run("Close");
	deleteMainfolder(Path + "/" + folder_name + "/");	
}

//------------------------------------------------//

function deleteMainfolder(folderPath) {    

    // Check if the folder exists
    if (File.exists(folderPath)) {
        // Get a list of all files and subfolders in the folder
        list = getFileList(folderPath);

        // Delete each file/subfolder
        for (i = 0; i < list.length; i++) {
            path = folderPath + "/" + list[i];
            if (File.isDirectory(path)) {
                // Recursively delete subfolder
                deletesubFolder(path);
            } else {
                // Delete file
                File.delete(path);
            }
        }

        // Delete the folder itself
        File.delete(folderPath);
    } else {
        print("Folder does not exist.");
    }
    selectWindow("Log"); run("Close");
}

//------------------------------------------------//

function deletesubFolder(folderPath) {
    list = getFileList(folderPath);
    for (i = 0; i < list.length; i++) {
        path = folderPath + "/" + list[i];
        if (File.isDirectory(path)) {
            deletesubFolder(path);
        } else {
            File.delete(path);
        }
    }
    File.delete(folderPath);
}

//------------------------------------------------//