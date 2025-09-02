process APPLY_AMST {
    label 'apply_amst'
    conda '/home/tatiana/miniconda3/envs/squirrel-env'    
    input:
    path(yaml_file)
    path(amst_transforms)


    output:
    path("*.tif"), emit: amst_tiffs
    path "completion_prealign.txt", emit: done

    script:
    """
    apply_amst.py  --input_yaml $yaml_file  --out_json . --amst_transforms $amst_transforms
    echo "done" > completion_prealign.txt
    """

}
