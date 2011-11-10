#!/bin/sh
# MIUI u8800 port script by Stockwell

# /app
cd new_miui/system/app
rm FM.apk
cd ..
cp -r ../../overlay/system/app .

# /bin
cd bin
rm akmd
rm bma150_usr
rm fmradioserver
rm htc_ebdlogd
cd ..
cp -r ../../overlay/system/bin .

# /etc
cd etc
rm firmware/Vision_SPK.acdb
rm firmware/bcm4329.hcd
rm firmware/default*
rm A1026_CFG.csv
rm AdieHWCodec*.csv
rm T-Mobile_USA*
rm ecclist_for_mcc.conf
cd ..
cp -r ../../overlay/system/etc .

# /lib
cd lib
rm -R hw
rm -R egl
rm -R modules
rm libfm*
rm libhtc*
rm librilswitch.so
cd ..
cp -r ../../overlay/system/lib .

# /usr
cd usr
rm keychars/vision*
rm keylayout/vision*
rm keylayout/h2w_headset.kl
cd ..
cp -r ../../overlay/system/usr .

# /vendor
rm -r vendor

# /cdrom
cp -r ../../overlay/system/cdrom .

cd ..

# install scripts
rm -r META-INF
cp -r ../overlay/META-INF .
cp ../overlay/backup_initd.sh .

cd ..

./overlay/build_prop.pl

#add additional english locales, and add correct values for tethering
cp new_miui/system/framework/framework-res.apk .
apktool if framework-res.apk
apktool d framework-res.apk
cd framework-res
cd res
cp -r values-en-rUS values-en-rAU
cp -r values-en-rUS values-en-rCA
cp -r values-en-rUS values-en-rGB
cp -r values-en-rUS values-en-rIE
cp -r values-en-rUS values-en-rNZ
cp ../../overlay/framework/arrays.xml values/arrays.xml
cd ..
cd ..
apktool b framework-res
cp framework-res/build/apk/resources.arsc .
zip -g framework-res.apk resources.arsc
cp framework-res.apk new_miui/system/framework/framework-res.apk

rm framework-res.apk
rm -R framework-res
rm resources.arsc

# check for changes in boot ramdisk (need to keep desire_z-ramdisk up to date)

cp new_miui/boot.img boot.img

sleep "1"
./overlay/unpack-bootimg.pl boot.img

dif=$(diff -r overlay/desire_z-ramdisk boot.img-ramdisk | wc -l)

if [ $dif -ne 0 ]; then
    echo "Differences found in boot ramdisk."
    xxdiff -r boot.img-ramdisk overlay/desire_z-ramdisk
else
    # straight copy boot image if it's not changed
    echo "Boot image unchanged"
    cp overlay/boot.img new_miui/boot.img
    rm -R boot.img-ramdisk
    cd new_miui
    zip -r /home/stockwell/MIUI.us_u8800_"$version"_Eng.zip system META-INF backup_initd.sh boot.img
fi


echo "all done."
