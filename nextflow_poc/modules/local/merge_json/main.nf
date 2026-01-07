process MERGE_JSON {
    label 'process_single'
    input:
    path(input_dir)
    val(json_file)

    output:
    path("*.json", emit: json_merge)

    script:
    def file_list = "'${input_dir.collect{ it.name }.join(',')}'"
    """
    #!/usr/bin/env python

    import os
    from squirrel.library.affine_matrices import load_affine_stack_from_multiple_files
    trans=$file_list
    trans_list=trans.split(',')
    cwd=os.getcwd()
    transform_filepaths=[ os.path.join(cwd,i) for i in trans_list]
    transforms = load_affine_stack_from_multiple_files(transform_filepaths, sequence_stack=False)
    transforms = transforms.get_sequenced_stack()
    transforms.to_file('${json_file}')

    """
    stub:
    """
    touch $json_file
    """

}
