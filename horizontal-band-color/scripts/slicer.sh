#!/bin/bash

IMAGE=$1                          # ./something/foo.png
IMAGEBASE=$(basename $IMAGE)      # foo.png
IMAGEBASENOEXT=${IMAGEBASE%%.*}    # foo
OUTBASE=out
OUTDIR=$OUTBASE/$IMAGEBASENOEXT


mkdir -p $OUTDIR

# start with RGB, so from 200 vertical pixels divided by 16 palettes = 320x12.5 (we'll do 13 and remove extras)
# we'll end up with 13 chunks of 320x13 (last one will be short) that are still full color
convert -resize 320x200! -crop 320x13 $IMAGE $OUTDIR/$IMAGEBASENOEXT-%03d.band.png

# reduce each band to a 16 color palette
for file in `ls $OUTDIR/$IMAGEBASENOEXT*.band.png`;
do
    echo Working on splice:  $file
    filebase=$(basename $file)
    filebasenoext=${filebase%%.*}
    dither=Riemersma
    dither=FloydSteinberg
    convert -colors 16 -depth 4 -dither $dither $file $OUTDIR/$filebasenoext.band16.png
done

convert -append $OUTDIR/$IMAGEBASENOEXT*band16* $OUTBASE/$IMAGEBASENOEXT-FINAL.png
