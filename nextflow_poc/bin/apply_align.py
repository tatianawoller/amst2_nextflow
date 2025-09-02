#!/usr/bin/env python3

"""
Proof of concept to run prealign like in AMST2
"""

from squirrel.workflows.elastix import elastix_stack_alignment_workflow
from squirrel.workflows.transformation import dot_product_on_affines_workflow
import os
from squirrel.workflows.transformation import apply_auto_pad_workflow
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
    parser.add_argument('--type_alignment', type=str, required=True, help='either sbs_alignment or nsbs_alignment')
    parser.add_argument('--out_json', type=str, required=True, help='Name of the output json.')
    parser.add_argument('--json_transform', type=str, required=True, help='Path to the json with the transforms.')
    return parser.parse_args()

def run_prealignment():
    cwd= os.getcwd()
    args= parse_arguments()
    parameter_dict = load_parameter_yaml(os.path.join(cwd,args.input_yaml))
    output_dirpath = args.out_json
    input_json= args.json_transform
    input_dirpath = parameter_dict['general']['input_dirpath']
    type_align= args.type_alignment

    if not os.path.exists(output_dirpath):
        os.mkdir(output_dirpath)

        

    apply_multi_step_stack_alignment_workflow(
            image_stack=input_dirpath,
            transform_paths=[os.path.join(output_dirpath, input_json)],  # List of transform files
            out_filepath=output_dirpath,
            pattern='*.tif', # was set to '*.tif' in the original code
            auto_pad=True,      
            target_image_shape=None, 
            z_range=None,       # Use all slices
            n_workers=1,
            write_result=True,        
            verbose=True        # Was set to True in the original code
        )

if __name__ == "__main__":
    run_prealignment()
