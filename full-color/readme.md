# Full-color 

This is based off of a concept seen on early systems to simulate separate Red, Green, and Blue scanlines in order to approximate a higher number of colors. 

## About
In this case we are targeting the 12-bit color space on the Apple IIgs (2^12 = 4096).  It color system allows 4-bits per channel, meaning I can have a red value from 0-15, a green value from 0-15, and a blue value from 0-15.  In hexadecimal it looks like this #$06FA, with the leftmost zero nibble being ignored on the IIgs. 

To approximate it here, we use imagemagick to perform the following conversion steps:

- resize the image to 320x67  -  because IIgs resolution is 320x200 and we want it 1/3 height so CEILING(66.66666)
- crop it into 67 images - each sized 320x1  - still all full color
- for each line: 
  - remove two channels (Green,Blue) to get remaining channel (Red)
  - reduce that channel to a 16 color, 12 bit, dithered image
  - recombine the 67 * 3 images into single 320x201 image
  - crop to 320x200, effectively dropping the last Blue line since we start with RGB at the top

## Prerequisite
You must have imagemagick installed.  To see if it's installed, open a command line and type `convert`

If you need to install it, for Mac OSX, I'd suggest `brew`:
```$ brew install imagemagick```

Linux - RHEL/CentOS
```$ sudo yum install ImageMagick```

Linux - Debian/Ubuntu
```$ sudo apt-get install imagemagick```

## Running the script to build an image
Basically you can just run the `slicer.sh` script against any image that imagemagick supports.

```./slicer.sh my_picture.png```

## Running the test suite

From the parent directory (the one this readme file is in), run the test script:
```$ ./tests/run_1.sh```

Output will be generated in the **out/** directory.