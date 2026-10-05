

// This macro aligns channel 1 and channel 2 of a z stack.
// This macro assumes that these 2 channels are colocalized.
// The input folder should consist of multiple .tif files. Each .tif file is a 2 channel z stack.
//
// Written by hui ting, 22 Sep 2021.


/////////////////////////////////////    Parameters    /////////////////////////////////////////////////////

max_shift_x = 10;
max_shift_y = 10;
max_shift_z = 10;

////////////////////////////////////////////////////////////////////////////////////////////////////////////


dir = getDirectory("Select your input folder");
list = getFileList(dir);

res_folder = dir+"Aligned"
File.makeDirectory(res_folder);

for (i = 0; i < list.length; i++) {

	if (endsWith(list[i], ".tif")){

open(dir+list[i]);
rename(list[i]);

Stack.getDimensions(width, height, channels, slices, frames);
getVoxelSize(pxl_sz1, pxl_sz2, pxl_sz3, pxl_unit);

run("Make Substack...", "channels=1-2 slices=1-"+slices);
run("Re-order Hyperstack ...", "channels=[Frames (t)] slices=[Slices (z)] frames=[Channels (c)]");
run("Correct 3D drift", "channel=1 only=0 lowest=1 highest="+slices+" max_shift_x="+max_shift_x+" max_shift_y="+max_shift_y+" max_shift_z="+max_shift_z);
run("Re-order Hyperstack ...", "channels=[Frames (t)] slices=[Slices (z)] frames=[Channels (c)]");
Stack.getDimensions(width2, height2, channels2, slices2, frames2);

setVoxelSize(pxl_sz1, pxl_sz2, pxl_sz3, pxl_unit);
saveAs("Tiff", res_folder+File.separator+list[i]+"_aligned.tif");
run("Close All");

		
		
	}
}







