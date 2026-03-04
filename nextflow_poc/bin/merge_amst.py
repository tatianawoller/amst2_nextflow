#!/usr/bin/env python3

from argparse import ArgumentParser
from squirrel.library.elastix import load_transform_stack_from_multiple_files

def create_argument_parser():
    """Create and return an argument parser."""
    parser = ArgumentParser()
    parser.add_argument('--file_list',  type=str, help='file_list')
    parser.add_argument('--outdir', type=str, help='output_dir')
    return parser

def concatenate_transformation(file_list,outdir):
    '''description'''
    trans_list=sorted(file_list.split(','), key=lambda x: int(x.split('_')[1]))
    transforms = load_transform_stack_from_multiple_files(trans_list)
    transforms.to_file(outdir)

if __name__ == "__main__":
    args = create_argument_parser()
    args = args.parse_args()
    concatenate_transformation(args.file_list, args.outdir)


