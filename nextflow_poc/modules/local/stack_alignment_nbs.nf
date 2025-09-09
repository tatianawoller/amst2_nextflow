process ELASTIX_STACK_ALIGNMENT_NBS {
    label 'elastix_stack_alignment_nbs'
    
    input:
    val(done)
    path(input_dir)  // Just the directory path
    path(yaml_file)
    val(type_align)

    output:
    path("*.json"), emit: json_transform

    script:
    """
    stack_align_nbs.py --input $input_dir --input_yaml $yaml_file --type_alignment $type_align --out_json .
    """
}
