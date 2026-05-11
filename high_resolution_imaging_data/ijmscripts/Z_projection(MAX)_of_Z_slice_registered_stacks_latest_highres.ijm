// Raghavan Thiagarajan, reNEW, Copenhagen, 2025 Spetember

// This script is used (only for high resolution data with one time point but with multiple Z slices and channels) for the Z projection of slices that correspond to the apical domain - when the apical domain is curved 

id = getImageID();
selectImage(id);
Path = getInfo("image.directory"); 
Stack.getDimensions(width, height, channels, slices, frames); totalslices = slices; totalframes = frames; totalchannels = channels;

Dialog.create("Slice information");
Dialog.addMessage("Info: \n(1) Position of apical slice - This is the position/slice number of the apical slice from Z registration \n(2) No. of slices before - No of slices before max intensity slice \n(3) No. of slices after - No of slices after max intensity slice"); 
Dialog.addNumber("Position of apical slice from Z registration:", 000);
Dialog.addNumber("No. of slices before:", 000);
Dialog.addNumber("No. of slices after:", 000);
Dialog.show();
apical_slice_no = Dialog.getNumber(); // This is the position / slice number of the apical slice in the stack that is to be used.
slicesbefore = Dialog.getNumber(); // No of slices before max intensity slice
slicesafter = Dialog.getNumber(); // No of slices after max intensity slice
totalzprojectslices = slicesbefore + 1 + slicesafter;

Dialog.create("Projection type");
Dialog.addChoice("Type:", newArray("Maximum", "Average"));
Dialog.show();
Projection_type  = Dialog.getChoice();

for (c = 1; c<=totalchannels; c++) {
	selectImage(id);
	run("Duplicate...", "duplicate channels=["+c+"]");
	rename("Zregistered(intensitybased)_c"+c+".tif");
}

startslicebefore = 1; endslicebefore = (apical_slice_no - slicesbefore)-1; startsliceZproject = (apical_slice_no - slicesbefore) ; 
endsliceZproject = (apical_slice_no + slicesafter); startsliceafter = (apical_slice_no + slicesafter)+1; endsliceafter = totalslices; 		

if (Projection_type=="Maximum") {
	// To perform Maximum intensity projection
	//setBatchMode(true);
	for (c=1; c<=totalchannels; c++) {
		for (t=1; t<=totalframes; t++) {
			namebefore = "Stack_before_" + c +"_"+ t; nameZproject = "Stack_Zproject_" + c +"_"+ t; nameafter = "Stack_after_" + c +"_"+ t; 	
			if (endslicebefore!=0) {
				selectWindow("Zregistered(intensitybased)_c"+c+".tif"); 				
				run("Duplicate...", "title=["+namebefore+"] duplicate range="+startslicebefore+"-"+endslicebefore+""); 
			}
			selectWindow("Zregistered(intensitybased)_c"+c+".tif"); 			
			run("Duplicate...", "title=["+nameafter+"] duplicate range="+startsliceafter+"-"+endsliceafter+""); 
			selectWindow("Zregistered(intensitybased)_c"+c+".tif"); 			
			run("Duplicate...", "title=["+nameZproject+"] duplicate range="+startsliceZproject+"-"+endsliceZproject+""); 
			selectWindow(""+nameZproject+""); 
			run("Z Project...", "start=1 stop="+totalzprojectslices+" projection=[Max Intensity]"); 
			selectWindow("MAX_"+""+nameZproject+""); rename("MAX_project"); 
			selectWindow(""+nameZproject+""); run("Close");
			zprojectname = "Concate_"+c+"_"+t; 
			if (endslicebefore!=0) {
				run("Concatenate...", "title=["+zprojectname+"] image1="+namebefore+" image2=MAX_project image3="+nameafter+" image4=[-- None --]");
			}
			else {
				run("Concatenate...", "title=["+zprojectname+"] image1=MAX_project image2="+nameafter+" image3=[-- None --] image4=[-- None --]");				
			}			
		}
		Finalzprojectname = "Zregistered(intensitybased)_ApicaldomainMaxZprojection_(" + startsliceZproject +"-"+ endsliceZproject +")_c"+ c;
		selectWindow(""+zprojectname+""); saveAs("tiff", Path + ""+Finalzprojectname+"" + ".tif"); 
		
		if (c==1) {
			Isolated_Zprojected_apicaldomain = "actin_Z(" + startsliceZproject +"-"+ endsliceZproject +")_MIP";
		}
		if (c==2) {
			Isolated_Zprojected_apicaldomain = "bb_Z(" + startsliceZproject +"-"+ endsliceZproject +")_MIP";
		}
		if (c==3) {
			Isolated_Zprojected_apicaldomain = "Check_channel_Z(" + startsliceZproject +"-"+ endsliceZproject +")_MIP";
		}
		
		setSlice(startsliceZproject);
		run("Duplicate...", "use");
		rename(""+Finalzprojectname+""); 
		
		//run("Duplicate...", "title=["+Finalzprojectname+"] duplicate slices="+startsliceZproject+"");
		saveAs("tiff", Path + ""+Isolated_Zprojected_apicaldomain+"" + ".tif"); 
		run("Close");
	}
	//setBatchMode(false);
}

else {
	// To perform Average intensity projection
	//setBatchMode(true);
	for (c=1; c<=2; c++) {
		for (t=1; t<=totalframes; t++) {
			namebefore = "Stack_before_" + c +"_"+ t; nameZproject = "Stack_Zproject_" + c +"_"+ t; nameafter = "Stack_after_" + c +"_"+ t; 						
			if (endslicebefore!=0) {
				selectWindow("Zregistered(intensitybased)_c"+c+".tif"); 
				run("Duplicate...", "title=["+namebefore+"] duplicate slices="+startslicebefore+"-"+endslicebefore+" frames="+t+"");				
			}			
			selectWindow("Zregistered(intensitybased)_c"+c+".tif"); 
			run("Duplicate...", "title=["+nameafter+"] duplicate slices="+startsliceafter+"-"+endsliceafter+" frames="+t+"");
			selectWindow("Zregistered(intensitybased)_c"+c+".tif"); 
			run("Duplicate...", "title=["+nameZproject+"] duplicate slices="+startsliceZproject+"-"+endsliceZproject+" frames="+t+"");
			selectWindow(""+nameZproject+""); 
			run("Z Project...", "start=1 stop="+totalzprojectslices+" projection=[Average Intensity]");
			selectWindow("AVG_"+""+nameZproject+""); rename("AVG_project");		
			selectWindow(""+nameZproject+""); run("Close");
			zprojectname = "Concate_"+c+"_"+t; 
			if (endslicebefore!=0) {
				run("Concatenate...", "title=["+zprojectname+"] image1="+namebefore+" image2=AVG_project image3="+nameafter+" image4=[-- None --]");				
			}
			else {
				run("Concatenate...", "title=["+zprojectname+"] image1=AVG_project image2="+nameafter+" image3=[-- None --] image4=[-- None --]");
			}			
		}
		zprojectname1 = "Concate_"+c+"_1"; zprojectname2 = "Concate_"+c+"_2"; zprojectname3 = "Concate_"+c+"_3"; 
		run("Concatenate...", "open image1="+zprojectname1+" image2="+zprojectname2+" image3="+zprojectname3+" image4=[-- None --]");
		for (t=4; t<=totalframes; t++) {
			zprojectname = "Concate_"+c+"_"+t;
			Finalzprojectname = "Zregistered(intensitybased)_ApicaldomainAvgZprojection_(" + startsliceZproject +"-"+ endsliceZproject +")_c"+ c;
			run("Concatenate...", "open image1=[Untitled] image2="+zprojectname+" image3=[-- None --]");		
		}
		Finalzprojectname = "Zregistered(intensitybased)_ApicaldomainAvgZprojection_(" + startsliceZproject +"-"+ endsliceZproject +")_c"+ c;
		selectWindow("Untitled"); saveAs("tiff", Path + ""+Finalzprojectname+"" + ".tif"); 

		if (c==1) {
			Isolated_Zprojected_apicaldomain = "Actin_ApicalDomain_Zprojected(" + startsliceZproject +"-"+ endsliceZproject +")_c"+ c;
		}
		if (c==2) {
			Isolated_Zprojected_apicaldomain = "BB_ApicalDomain_Zprojected(" + startsliceZproject +"-"+ endsliceZproject +")_c"+ c;
		}
		if (c==3) {
			Isolated_Zprojected_apicaldomain = "BF_ApicalDomain_Zprojected(" + startsliceZproject +"-"+ endsliceZproject +")_c"+ c;
		}
		run("Duplicate...", "title=["+Finalzprojectname+"] duplicate slices="+startsliceZproject+"");
		saveAs("tiff", Path + ""+Isolated_Zprojected_apicaldomain+"" + ".tif"); 
		run("Close");
	}
	//setBatchMode(false);
}
 run("Close All");




