#!/bin/bash

amst2-stack_to_ome_zarr  /home/tatiana/data_HR/taturtlesorted_amst  /home/tatiana/data_HR/zarrd4  --cores 8 --batch_size 16 --resolution 0.008 0.006 0.006  --unit "micrometer" --stack_key "s0" 
sq-elastix-make_default_parameter_file default_param.txt --transform "amst-bspline" -elx FinalGridSpacingInPhysicalUnits:128 GridSpacingSchedule:4.0,3.0,2.0,1.0 MaximumStepLength:0.5 MaximumNumberOfIterations:1024
amst2-amst /home/tatiana/data_HR/zarrd4/taturtlesorted_amst.ome.zarr /home/tatiana/data_HR/amstd4 -out-oz-fn amst.zarr --transform "bspline" --elastix_parameter_file default_param.txt --cores 8 --batch_size 16 -mr 7 -gs 2.0 --continue_run
amst2-apply_transformation /home/tatiana/data_HR/zarrd4/taturtlesorted_amst.ome.zarr  /home/tatiana/data_HR/amstd4/amst.zarr.meta/amst  /home/tatiana/data_HR/amstd4 --cores 8 --batch_size 16 --resolution 0.008 0.006 0.006  --unit "micrometer" --stack_key "s0"  --no_autopad  --continue_run
amst2-ome_zarr_to_stack   /home/tatiana/data_HR/amstd4/amst.ome.zarr  /home/tatiana/data_HR/result_amst_amst2  amst2_d4 --cores 8 --batch_size 16 
