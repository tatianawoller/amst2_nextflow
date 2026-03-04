process MERGE_AMST {
    label 'process_single'
    input:
    path(input_dir)
    val(out_dir)

    output:
    path("${out_dir}", emit: json_merge)

    script:
    def file_list = "'${input_dir.collect{ it.name }.join(',')}'"
    """
    #!/usr/bin/env python

    import os
    from squirrel.library.elastix import load_transform_stack_from_multiple_files
    output_directory = "${out_dir}"
    trans_list=sorted(${file_list}.split(","), key=lambda x: int(x.split('_')[1]))
    transforms = load_transform_stack_from_multiple_files(trans_list)
    transforms.to_file("${out_dir}")
    """
    stub:
    """
    mkdir -p $out_dir
    """

}
