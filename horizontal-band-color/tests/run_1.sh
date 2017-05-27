#!/bin/bash
# run from parent dir "./tests/run_1.sh"
for i in `ls ../sample_images`
do
    ./scripts/slicer.sh ../sample_images/$i
done
