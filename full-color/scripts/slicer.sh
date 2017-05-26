#!/bin/bash

IMAGE=$1                          # ./something/foo.png
IMAGEBASE=$(basename $IMAGE)      # foo.png
IMAGEBASENOEXT=${IMAGEBASE%%.*}    # foo
OUTBASE=out
OUTDIR=$OUTBASE/$IMAGEBASENOEXT


mkdir -p $OUTDIR

# start with RGB, so from 200 vertical pixels divided by 3 colors = 320x66.6 (we'll do 67 and remove extras)
# also, we don't reduce colors yet, because we need 67 full-color lines to split into three separate
# 4-bpc (12bit color) lines to composite at the end
convert -resize 320x67\!  -crop 320x1 $IMAGE $OUTDIR/$IMAGEBASENOEXT-%03d.full.png

for file in `ls $OUTDIR/$IMAGEBASENOEXT*.full.png`;
do
    echo Working on splice:  $file
    filebase=$(basename $file)
    filebasenoext=${filebase%%.*}
    dither=Riemersma
    convert -channel Green,Blue -evaluate set 0 +channel -colors 16 -depth 12 -dither $dither $file $OUTDIR/$filebasenoext.gs.0-R.png
    convert -channel Red,Blue   -evaluate set 0 +channel -colors 16 -depth 12 -dither $dither $file $OUTDIR/$filebasenoext.gs.1-G.png
    convert -channel Red,Green  -evaluate set 0 +channel -colors 16 -depth 12 -dither $dither $file $OUTDIR/$filebasenoext.gs.2-B.png
done

convert -append $OUTDIR/$IMAGEBASENOEXT*gs* $OUTDIR/$IMAGEBASENOEXT-FINAL.png
convert -crop 320x200 $OUTDIR/$IMAGEBASENOEXT-FINAL.png $OUTBASE/$IMAGEBASENOEXT-FINAL-APPX.png
