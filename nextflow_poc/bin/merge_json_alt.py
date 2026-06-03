#!/usr/bin/env python3

from pathlib import Path
from argparse import ArgumentParser
import os
from squirrel.library.affine_matrices import load_affine_stack_from_multiple_files

def create_argument_parser():
    """Create and return an argument parser."""
    parser = ArgumentParser()
    parser.add_argument('--json_list',  type=str, help='list_json')
    parser.add_argument('--json_file', type=str, help='output_json')
    return parser

def concatenate_json_file(trans,json_file:str):
    '''description'''
    cwd=os.getcwd()
    trans_list=trans.split(',')
    trans_list=sorted(trans_list, key=lambda x: int(x.split('_')[1]))
    cwd=os.getcwd()
    transform_filepaths=[ os.path.join(cwd,i) for i in trans_list]
    transforms = load_affine_stack_from_multiple_files(transform_filepaths, sequence_stack=False)
    transforms = transforms.get_sequenced_stack()
    transforms.to_file(json_file)

if __name__ == "__main__":
    args = create_argument_parser()
    args = args.parse_args()
    print(args)
    concatenate_json_file(str(args.json_list), args.json_file)


