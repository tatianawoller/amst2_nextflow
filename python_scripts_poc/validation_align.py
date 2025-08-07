

from squirrel.workflows.elastix import stack_alignment_validation_workflow
import argparse

def parser():
    """Parse command line arguments"""      
    parser = argparse.ArgumentParser(description="Run AMST aligned test workflow")
    parser.add_argument('--stack', type=str, required=True, help="Path to the input image stack")
    parser.add_argument('--out_dirpath', type=str, required=True, help="Output directory path for results")
    parser.add_argument('--rois', type=str, required=True, help="Path to the ROIs file")
    parser.add_argument('--method', type=str, help="Which method to use for alignment (default: elastix)", default='elastix')
    parser.add_argument('--pattern', type=str, default='*.tif', help="File pattern to match images")
    parser.add_argument('--ymax', type=int, default=None, help="Maximum Y coordinate for the stack")

    return parser

def main():
    args = parser().parse_args()
    stack_alignment_validation_workflow(
        args.stack,
        args.out_dirpath,
        args.rois,
    #    key='data',
        args.pattern,
        resolution_yx=(1.0, 1.0),
        out_name=None,
        y_max=10,
        method=args.method,
    #    gaussian_sigma=1.0,
    #    subtract_average=False,
    #    verbose=False
)

if __name__ == "__main__":
    main()
