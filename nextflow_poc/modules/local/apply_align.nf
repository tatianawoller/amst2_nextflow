process APPLY_ELASTIX_ALIGNMENT {
    label 'apply_elastix_stack_alignment'
    conda '/home/tatiana/miniconda3/envs/squirrel-env'    
    input:
    path(yaml_file)
    val(type_align)
    val(output_json)

    output:
    path("*.tif"), emit: tif_aligned
    path "completion.txt", emit: done

    script:
    """
    apply_align.py  --input_yaml $yaml_file --type_alignment $type_align --out_json . --json_transform $output_json
    echo "done" > completion.txt
    """

}

