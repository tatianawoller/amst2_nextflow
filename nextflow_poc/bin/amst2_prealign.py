#!/usr/bin/env python3

"""
Proof of concept to run prealign like in AMST2
"""

from squirrel.workflows.elastix import elastix_stack_alignment_workflow
import os
import yaml
import argparse
from squirrel.workflows.elastix import apply_multi_step_stack_alignment_workflow
from squirrel.workflows.transformation import dot_product_on_affines_workflow
from squirrel.workflows.transformation import apply_auto_pad_workflow

def load_parameter_yaml(parameter_yaml):

    with open(parameter_yaml, 'r') as file:
        parameter_dict = yaml.safe_load(file)

    return parameter_dict

def parse_arguments():
    parser = argparse.ArgumentParser(description="Run stack alignment using prealignment parameters.")
    parser.add_argument('--input', type=str, required=True, help='Path to the parameter YAML file.')
    parser.add_argument('--out_dir', type=str, required=True, help='output directory.')
    parser.add_argument('--workers', type=int, default=1, help='Number of workers to use.')
    return parser.parse_args()

def run_prealignment():
    cwd= os.getcwd()
    args= parse_arguments()
    output_dirpath = args.out_dir
    input=args.input
    n_workers=args.workers

    if not os.path.exists(output_dirpath):
        os.mkdir(output_dirpath)
    
    output_json="elastix_sbs.json"
    parameter_dict = load_parameter_yaml(os.path.join(cwd,input))
    input_dirpath = parameter_dict['general']['input_dirpath']
    elastix_stack_alignment_workflow(
        stack=input_dirpath,
        out_filepath=os.path.join(output_dirpath, output_json),
        transform='translation',  # or 'rigid', 'affine', 'translation'
        pattern='*.tif',
        auto_mask=parameter_dict['sbs_alignment']['auto_mask'],  
        number_of_spatial_samples=parameter_dict['sbs_alignment']['elx_number_of_spatial_samples'],
        number_of_resolutions=parameter_dict['sbs_alignment']['elx_number_of_resolutions'],
        maximum_number_of_iterations=parameter_dict['sbs_alignment']['elx_maximum_number_of_iterations'],
        z_step=parameter_dict['sbs_alignment']['z_step'],  
        determine_bounds=True,
        gaussian_sigma=parameter_dict['sbs_alignment']['gaussian_sigma'],
        n_workers=n_workers

    )
    apply_multi_step_stack_alignment_workflow(
            image_stack=input_dirpath,
            transform_paths=[os.path.join(output_dirpath, "elastix_sbs.json")],  # List of transform files
            out_filepath=os.path.join(output_dirpath,'sbs_alignment'),
            pattern='*.tif', # was set to '*.tif' in the original code
            auto_pad=True,      
            target_image_shape=None, 
            z_range=None,       # Use all slices
            n_workers= n_workers,
            write_result=True,        
            verbose=True        # Was set to True in the original code
        )
    elastix_stack_alignment_workflow(
        stack=os.path.join(output_dirpath,'sbs_alignment'),
        out_filepath=os.path.join(output_dirpath, "elastix_nsbs.json"),
        transform='translation',  # or 'rigid', 'affine', 'translation'
        pattern='*.tif',
        auto_mask=parameter_dict['nsbs_alignment']['auto_mask'], 
        z_step=parameter_dict['nsbs_alignment']['z_step'],  
        apply_z_step=True,
        gaussian_sigma=parameter_dict['nsbs_alignment']['gaussian_sigma'],
        n_workers=n_workers
    )
    dot_product_on_affines_workflow(
        [
            os.path.join(output_dirpath, "elastix_sbs.json"),
            os.path.join(output_dirpath, "elastix_nsbs.json")
        ],
        os.path.join(output_dirpath, 'combined.json'),
        keep_meta=0,
    )

    apply_auto_pad_workflow(
        os.path.join(output_dirpath, 'combined.json'),
        os.path.join(output_dirpath, 'nsbs-pre-align.json'),
    )

    apply_multi_step_stack_alignment_workflow(
            image_stack=input_dirpath,
            transform_paths=[os.path.join(output_dirpath, 'nsbs-pre-align.json')],  # List of transform files
            out_filepath=os.path.join(output_dirpath, 'prealigned'),
            pattern='*.tif',
            auto_pad=True,      
            target_image_shape=None, 
            z_range=None,       # Use all slices
            write_result=True,
            n_workers= n_workers        
        )

if __name__ == "__main__":
    run_prealignment()
