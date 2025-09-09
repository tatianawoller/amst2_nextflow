process APPLY_ELASTIX_PREALIGNMENT {
    label 'apply_elastix_stack_prealignment'    
    input:
    path(yaml_file)
    val(sbs_json)
    val(nsbs_json)

    output:
    path("*.tif"), emit: tif_prealigned
    path("combined.json"), emit: combined_json
    path("nsbs-pre-align.json"), emit: prealign_json
    path "completion_prealign.txt", emit: done

    script:
    """
    apply_prealign.py  --input_yaml $yaml_file  --out_json . --sbs_json $sbs_json --nsbs_json $nsbs_json
    echo "done" > completion_prealign.txt
    """

}
