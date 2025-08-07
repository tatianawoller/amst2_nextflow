# AMST2_nextflow

## Plan
- run prealign_amst2, amst, prealign_amst2 + amst_amst2 using a conda environment based on squirrel 
- implement prealign_amst2, amst, prealign_amst2 as a nextflow subworkflow within a AMST2 nextflow module using conda
- implement prealign_amst2, amst, prealign_amst2 as a nextflow subworkflow within a AMST2 nextflow module using docker/apptainer

## Current state
- :construction: prealignment crashes at the third step (transformation.dot_product_on_affines_workflow)
- :construction: amst is only tested on the test data that was aligned with TM

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
```
