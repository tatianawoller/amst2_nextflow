#!/usr/bin/env python3

"""
Proof of concept to run prealign like in AMST2
"""

from squirrel.workflows.elastix import elastix_stack_alignment_workflow
import os
import yaml
import argparse

def load_parameter_yaml(parameter_yaml):

    with open(parameter_yaml, 'r') as file:
        parameter_dict = yaml.safe_load(file)

    return parameter_dict

def parse_arguments():
    parser = argparse.ArgumentParser(description="Run stack alignment using prealignment parameters.")
    parser.add_argument('--input', type=str, required=True, help='Path to the parameter YAML file.')
    parser.add_argument('--input_yaml', type=str, required=True, help='Path to the parameter YAML file.')
    parser.add_argument('--type_alignment', type=str, required=True, help='either sbs_alignment or nsbs_alignment')
    parser.add_argument('--out_json', type=str, required=True, help='Name of the output json.')
    return parser.parse_args()

def run_prealignment():
    cwd= os.getcwd()
    args= parse_arguments()
    yaml_file= args.input_yaml
    output_dirpath = args.out_json
    type_align= args.type_alignment
    input=args.input

    if not os.path.exists(output_dirpath):
        os.mkdir(output_dirpath)
    parameter_dict = load_parameter_yaml(os.path.join(cwd,yaml_file))
    output_json="elastix_nsbs.json"
    elastix_stack_alignment_workflow(
        stack=input,
        out_filepath=os.path.join(output_dirpath, output_json),
        transform='translation',  # or 'rigid', 'affine', 'translation'
        pattern='*.tif',
        auto_mask=parameter_dict[type_align]['auto_mask'], 
        z_step=parameter_dict[type_align]['z_step'],  
        apply_z_step=True,
        gaussian_sigma=parameter_dict[type_align]['gaussian_sigma']

    ) 
   

if __name__ == "__main__":
    run_prealignment()

