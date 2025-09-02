# AMST2_nextflow

## Plan
- run prealign_amst2, amst, prealign_amst2 + amst_amst2 using a conda environment based on squirrel 
- implement 2 use cases: prealign + amst ( from amst2), amst  as 2 nextflow subworkflows within a AMST2 nextflow module using conda
- test 2 use cases: prealign + amst ( from amst2), amst subworkflows within a AMST2 nextflow module using docker/apptainer

## Current state
- prealignment works as a python script and a nextflow workflow
- :construction: amst is only tested on the test data that was aligned with TM,using a dummy transformation but (apply_multi_step_stack_alignment_workflow ) does not lead to any new file

## Test data
- for alignment: 1st 32 slide of raw data at https://www.ebi.ac.uk/empiar/EMPIAR-10311/
- for amst (w/o prealignment): 1st 32 slide of data aligned with TM at https://www.ebi.ac.uk/empiar/EMPIAR-10311/

## Installation
- see the general part of squirrel + registration + pyyaml [squirrel](https://github.com/jhennies/squirrel/tree/main)

## Usage
```bash
# for registration and so far I have added the prealignment.py in squirrel
python  prealignment.py
# for amst and so far I have added the amst.py in squirrel
python  amst.py
# to test the align validation
python test_align.py -stack ../../test_data_julian/20140801_hela-wt_xy5z8nm_as/mini_amst/ --out_dirpath ../../test_data_julian/20140801_hela-wt_xy5z8nm_as/  --method "elastix" --rois "0,1,2828,6616,20,256,256"'
```
