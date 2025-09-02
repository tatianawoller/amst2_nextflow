#!/usr/bin/env python3

"""
Proof of concept to run prealign like in AMST2
"""

from squirrel.workflows.elastix import elastix_stack_alignment_workflow
from squirrel.workflows.transformation import dot_product_on_affines_workflow
from squirrel.workflows.transformation import apply_auto_pad_workflow
from squirrel.workflows.elastix import apply_multi_step_stack_alignment_workflow
import os
import yaml
import argparse

def load_parameter_yaml(parameter_yaml):

    with open(parameter_yaml, 'r') as file:
        parameter_dict = yaml.safe_load(file)

    return parameter_dict

def parse_arguments():
    parser = argparse.ArgumentParser(description="Run stack alignment using prealignment parameters.")
    parser.add_argument('--input_yaml', type=str, required=True, help='Path to the parameter YAML file.')
    parser.add_argument('--amst_transforms', type=str, required=True, help='Path to the sbs json file.')
    parser.add_argument('--out_json', type=str, required=True, help='Name of the output json.')
    return parser.parse_args()

def run_prealignment():
    cwd= os.getcwd()
    args= parse_arguments()
    output_dirpath = args.out_json
    input=args.input_yaml
    json_transforms=args.amst_transforms

    if not os.path.exists(output_dirpath):
        os.mkdir(output_dirpath)

    parameter_dict = load_parameter_yaml(os.path.join(cwd,input))
    input_dirpath = parameter_dict['general']['input_dirpath']
    pre_align_dirpath = parameter_dict['general']['pre_align_dirpath']
    apply_multi_step_stack_alignment_workflow(
            image_stack=pre_align_dirpath,
            transform_paths=[json_transforms],  # List of transform files
            out_filepath=output_dirpath,
            pattern='*.tif',
            auto_pad=True,      
            target_image_shape=None, 
            z_range=None,       # Use all slices
            n_workers=1,        
            write_result=True
        )

   

if __name__ == "__main__":
    run_prealignment()

