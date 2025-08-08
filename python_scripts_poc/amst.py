#!/usr/bin/env python3

"""
Proof of concept to run prealign like in AMST2
"""

#from squirrel.workflows.elastix import make_elastix_default_parameter_file_workflow
from squirrel.workflows.amst import amst_workflow
import os
from squirrel.workflows.elastix import apply_multi_step_stack_alignment_workflow
import yaml
#import glob

def load_parameter_yaml(parameter_yaml):

    with open(parameter_yaml, 'r') as file:
        parameter_dict = yaml.safe_load(file)

    return parameter_dict

def run_amst():
    
    parameter_dict = load_parameter_yaml("/home/twoller/AMST2/squirrel/params-amst.yaml")
    output_dirpath = parameter_dict['general']['output_dirpath']
    input_dirpath = parameter_dict['general']['input_dirpath']
    pre_align_dirpath = parameter_dict['general']['pre_align_dirpath']


    # FinalGridSpacingInPhysicalUnits:256 GridSpacingSchedule:4.0,3.0,2.0,1.0 MaximumStepLength:0.5 MaximumNumberOfIterations:1024
    # if  not parameter_dict['general']['pre_align_transforms'] and parameter_dict['amst']['elastix_parameter_file'] != 'auto':
    #     make_elastix_default_parameter_file_workflow(
    #         out_filepath=os.path.join(output_dirpath, "elastix-params-amst-gs256.txt"),
    #         transform='affine',  # or 'rigid', 'affine', 'translation'
    #        # final_grid_spacing_in_physical_units=256,
    #     #    grid_spacing_schedule=[4.0,3.0,2.0,1.0],
    #        # maximum_number_of_iterations=1024,
    #       #  maximum_step_length=0.5
    # )
    #     elastix_parameters=os.path.join(output_dirpath, "elastix-params-amst-gs256.txt")
    #     parameter_dict['amst']['elastix_parameters'] = elastix_parameters
    

    # just for testing puporse

   # elastix_param_files = glob.glob("elastix_params_amst_dummy.txt")
    amst_workflow(
        pre_align_dirpath,
        os.path.join(output_dirpath,'amst-transforms'),
        raw_stack=None,
        pre_align_key='data',
        pre_align_pattern='*.tif',
        transform=[parameter_dict['amst']['transform']],
        auto_mask_off=parameter_dict['amst']['auto_mask_off'],
        median_radius=parameter_dict['amst']['median_radius'],
        z_smooth_method='median',
        z_range=None,
        gaussian_sigma=parameter_dict['amst']['gaussian_sigma'],
        elastix_parameters=parameter_dict['amst']['elastix_parameter_file'],
       # elastix_parameters=parameter_dict['amst']['elastix_parameter_file'], # what should be if running amst2 entirely
        crop_to_bounds_off=False,
        quiet=False,
        try_again=False,
        verbose=False
    )


    apply_multi_step_stack_alignment_workflow(
            image_stack=pre_align_dirpath,
            transform_paths=[os.path.join(output_dirpath, 'amst-transforms')],  # List of transform files
            out_filepath=os.path.join(output_dirpath, 'amst'),
            pattern='*.tif',
            auto_pad=True,      
            target_image_shape=None, 
            z_range=None,       # Use all slices
            n_workers=1,        
            verbose=False        # Was set to True in the original code
        )

if __name__ == "__main__":
    run_amst()
    
