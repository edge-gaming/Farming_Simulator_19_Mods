#/bin/sh
CONVERTER=../../../../../../../giants/bin/textureConverter

$CONVERTER -colorspace srgb -verbose -channels 3 -arch pvr -outfile ground_diffuse -array 5 source/cultivator_diffuse.png source/acre_diffuse.png source/acre_fine_diffuse.png source/acre_plantedRows_diffuse.png source/acre_grassGrowth_diffuse.png
$CONVERTER -colorspace linear -verbose -channels 3 -arch pvr -outfile ground_normal -array 5 source/cultivator_normal.png source/acre_normal.png source/acre_fine_normal.png source/acre_plantedRows_normal.png source/acre_grassGrowth_normal.png

$CONVERTER -colorspace srgb -verbose -channels 3 -arch pvr -outfile ground2_diffuse -array 5 source/cultivator_diffuse.png source/acre_diffuse.png source/acre_fine_diffuse.png source/acre_plantedRows_diffuse.png source/acre_grassGrowth2_diffuse.png
$CONVERTER -colorspace linear -verbose -channels 3 -arch pvr -outfile ground2_normal -array 5 source/cultivator_normal.png source/acre_normal.png source/acre_fine_normal.png source/acre_plantedRows_normal.png source/acre_grassGrowth2_normal.png
