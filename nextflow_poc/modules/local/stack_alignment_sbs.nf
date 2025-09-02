process ELASTIX_STACK_ALIGNMENT_SBS {
    label 'elastix_stack_alignment_sbs'
    conda '/home/tatiana/miniconda3/envs/squirrel-env'    
    input:
    path(yaml_file)
    val(type_align)
 

    output:
    path("*.json"), emit: json_transform

    script:
    """
    stack_align_sbs.py  --input $yaml_file --type_alignment $type_align --out_json .

    """

}
