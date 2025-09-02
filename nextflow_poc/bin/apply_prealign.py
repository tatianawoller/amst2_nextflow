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
    parser.add_argument('--sbs_json', type=str, required=True, help='Path to the sbs json file.')
    parser.add_argument('--nsbs_json', type=str, required=True, help='Path to the nsbs json file.')
    parser.add_argument('--out_json', type=str, required=True, help='Name of the output json.')
    return parser.parse_args()

def run_prealignment():
    cwd= os.getcwd()
    args= parse_arguments()
    output_dirpath = args.out_json
    sbs_json= args.sbs_json
    nsbs_json= args.nsbs_json
    input=args.input_yaml

    if not os.path.exists(output_dirpath):
        os.mkdir(output_dirpath)
    
    output_json="elastix_sbs.json"
    parameter_dict = load_parameter_yaml(os.path.join(cwd,input))
    input_dirpath = parameter_dict['general']['input_dirpath']
    dot_product_on_affines_workflow(
        [
            os.path.join(output_dirpath, sbs_json),
            os.path.join(output_dirpath, nsbs_json)
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
            out_filepath=os.path.join(output_dirpath),
            pattern='*.tif',
            auto_pad=True,      
            target_image_shape=None, 
            z_range=None,       # Use all slices
            write_result=True,
            n_workers=1,        
        )

   

if __name__ == "__main__":
    run_prealignment()

