#!/usr/bin/env python3

"""
Proof of concept to run prealign like in AMST2
"""

from squirrel.workflows.elastix import make_elastix_default_parameter_file_workflow
from squirrel.workflows.amst import amst_workflow
import os
from squirrel.workflows.elastix import apply_multi_step_stack_alignment_workflow
import yaml
import argparse

def load_parameter_yaml(parameter_yaml):

    with open(parameter_yaml, 'r') as file:
        parameter_dict = yaml.safe_load(file)

    return parameter_dict

def parse_arguments():
    parser = argparse.ArgumentParser(description="Run stack alignment using prealignment parameters.")
    parser.add_argument('--input_yaml', type=str, required=True, help='Path to the parameter YAML file.')
    parser.add_argument('--out_dir', type=str, required=True, help='Name of the output json.')
    parser.add_argument('--workers', type=int, default=1, help='Number of workers to use.')
    parser.add_argument('--prealign_dir', nargs='+', required=True, help='Path to the prealigned directory.')
    return parser.parse_args()

def run_amst():
    cwd= os.getcwd()
    args= parse_arguments()
    output_dirpath = args.out_dir
    input=args.input_yaml
    n_workers=args.workers
    pre_align_dirpath = os.path.commonpath(args.prealign_dir)

    if not os.path.exists(output_dirpath):
        os.mkdir(output_dirpath)
    if not os.path.exists(os.path.join(output_dirpath, 'amst-transforms')):
        os.mkdir(os.path.join(output_dirpath, 'amst-transforms'))
    parameter_dict = load_parameter_yaml(os.path.join(cwd,input))
   # output_dirpath = parameter_dict['general']['output_dirpath']
   # input_dirpath = parameter_dict['general']['input_dirpath']
    #pre_align_dirpath = parameter_dict['general']['pre_align_dirpath']
   # pre_align_transforms = parameter_dict['general']['pre_align_transforms']
    
    
    make_elastix_default_parameter_file_workflow(
             out_filepath=os.path.join(output_dirpath, "elastix-params-amst-gs256.txt"),
             transform='bspline')

    amst_workflow(
        pre_align_dirpath,
        os.path.join(output_dirpath, 'amst-transforms'),
        raw_stack=None,
        pre_align_key='data',
        pre_align_pattern='*.tif',
        transform=[parameter_dict['amst']['transform']],
        auto_mask_off=parameter_dict['amst']['auto_mask_off'],
        median_radius=parameter_dict['amst']['median_radius'],
        z_smooth_method='median',
        z_range=None,
        gaussian_sigma=parameter_dict['amst']['gaussian_sigma'],
        elastix_parameters=os.path.join(output_dirpath, "elastix-params-amst-gs256.txt"),
        crop_to_bounds_off=False,
        quiet=False,
        try_again=False,
        verbose=False,
        n_workers=n_workers
    )
    apply_multi_step_stack_alignment_workflow(
            image_stack=pre_align_dirpath,
            transform_paths=[os.path.join(output_dirpath, 'amst-transforms')],  # List of transform files
            out_filepath=os.path.join(output_dirpath,'amst'),
            pattern='*.tif',
            auto_pad=True,      
            target_image_shape=None, 
            z_range=None,       # Use all slices
            n_workers= n_workers,        
            write_result=True
        )

   

if __name__ == "__main__":
    run_amst()
