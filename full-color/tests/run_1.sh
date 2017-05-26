#!/bin/bash
# run from parent dir "./tests/run_1.sh"
for i in lion.jpg painting-swirl.jpg pink-cosmos.jpg radiant-color.jpg ;
do
    ./scripts/slicer.sh ../sample_images/$i
done
