#! /usr/bin/perl
open(file, "new_miui/system/build.prop");	
@desire_z_buildprop = <file> ;
close(file);

if(@desire_z_buildprop[13]=~u8800){
	die("already patched build.prop");
}
$modversion = @desire_z_buildprop[5];
$modversion = substr($modversion, 0, -7);
$display_id = @desire_z_buildprop[8];
$version_incremental = @desire_z_buildprop[9];
$build_date = @desire_z_buildprop[13];
$build_date_utc = @desire_z_buildprop[14];
$build_description = @desire_z_buildprop[34];
$build_fingerprint = @desire_z_buildprop[35];

open(build_file, "overlay/system/build.prop");
@buildprop = <build_file>;
close(build_file);
@buildprop[4] = "${modversion}u8800\n";
@buildprop[7] = $display_id;
@buildprop[8] = $version_incremental;
@buildprop[12] = $build_date;
@buildprop[13] = $build_date_utc;
@buildprop[33] = $build_description;
@buildprop[34] = $build_fingerprint;

open(OUT, ">new_miui/system/build.prop");
print OUT @buildprop;
close(OUT);



