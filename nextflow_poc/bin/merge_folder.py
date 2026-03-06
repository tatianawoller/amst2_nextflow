#!/usr/bin/env python3

import os
import re
from pathlib import Path
from shutil import copy2
from argparse import ArgumentParser

def extract_boundaries(folder_name, stem_name):
    """Extract start and end indices from folder name """
    match = re.search(f'{stem_name}(\\d+)_(\\d+)', folder_name)
    if match:
        start = int(match.group(1))
        end = int(match.group(2))
        return start, end
    return None, None

def copy_and_rename_files(source_folder, dest_folder, start_index, end_index):
    """
    Copy files from source folder to destination, renaming with indices in range [start_index, end_index).
    """
    os.makedirs(dest_folder, exist_ok=True)
    files = sorted([f for f in os.listdir(source_folder) if os.path.isfile(os.path.join(source_folder, f))])
    indices = list(range(start_index, end_index))
    if len(files) != len(indices):
        print(f"Warning: {len(files)} files found but {len(indices)} indices available for range [{start_index}, {end_index})")

    for filename, new_index in zip(files, indices):
        source_path = os.path.join(source_folder, filename)
        match = re.match(r'(slice_)(\d+)(\..*)', filename)
        if match:
            prefix = match.group(1)
            extension = match.group(3)
            new_filename = f"{prefix}{new_index}{extension}"
        else:
            new_filename = filename
        dest_path = os.path.join(dest_folder, new_filename)
        copy2(source_path, dest_path)

def create_argument_parser():
    """Create and return an argument parser."""
    parser = ArgumentParser()
    parser.add_argument('--folder_list', help='list of folders')
    parser.add_argument('--output_dir', help='output_dir')
    return parser

if __name__ == "__main__":
    args = create_argument_parser()
    args = args.parse_args()
    cwd=os.getcwd()
    folder_list=args.folder_list.split(",")
    print(folder_list)
    for folder_name in folder_list:
        source_folder = os.path.join(cwd, folder_name)
        start_idx, end_idx = extract_boundaries(folder_name,args.output_dir)
        if start_idx is None:
            print(f"Could not extract boundaries from {folder_name}")
            continue
        copy_and_rename_files(source_folder, args.output_dir, start_idx, end_idx)


