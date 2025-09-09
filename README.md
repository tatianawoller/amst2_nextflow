# AMST2_nextflow

## Plan
- run prealign_amst2 using a conda environment or apptainer based on squirrel ✔️
- run prealign_amst2 using  apptainer based on squirrel ✔️
- implementation subworkflow ✔️
- implement 2 use cases: prealign + amst ( from amst2), amst  as 2 nextflow subworkflows within a AMST2 nextflow module using conda 🚧
- test 2 use cases: prealign + amst ( from amst2), amst subworkflows within a AMST2 nextflow module using docker  🚧
- test on hpc🚧

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
# when nextflow is available
nextflow main.nf
# to test the align validation
# works when changing line 326 in elastix.py by if auto_mask is not None and auto_mask is not False:
# check y_max
stack_alignment_validation /home/twoller/AMST2/results/amst/amst /home/twoller/AMST2/results/amst/val "13,536,2050,32,256,256" --out_name test --y_max 10'
# how to have multiple plots in one plot ?
```
