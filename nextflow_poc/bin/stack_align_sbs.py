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
    parser.add_argument('--type_alignment', type=str, required=True, help='either sbs_alignment or nsbs_alignment')
    parser.add_argument('--out_json', type=str, required=True, help='Name of the output json.')
    return parser.parse_args()

def run_prealignment():
    cwd= os.getcwd()
    args= parse_arguments()
    output_dirpath = args.out_json
    type_align= args.type_alignment
    input=args.input

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
        auto_mask=parameter_dict[type_align]['auto_mask'],  
        number_of_spatial_samples=parameter_dict[type_align]['elx_number_of_spatial_samples'],
        number_of_resolutions=parameter_dict[type_align]['elx_number_of_resolutions'],
        maximum_number_of_iterations=parameter_dict[type_align]['elx_maximum_number_of_iterations'],
        z_step=parameter_dict[type_align]['z_step'],  
        determine_bounds=True,
        gaussian_sigma=parameter_dict[type_align]['gaussian_sigma']

    )

   

if __name__ == "__main__":
    run_prealignment()

