process ELASTIX_STACK_ALIGNMENT {
    label 'elastix_stack_alignment'
    conda '/home/tatiana/miniconda3/envs/squirrel-env'    
    input:
    path(yaml_file)
    val(type_align)
    val(output_json)

    output:
    path("*.json"), emit: json_transform

    script:
    """
    stack_align.py  --input_yaml $yaml_file --type_alignment $type_align --out_json .

    """

}
