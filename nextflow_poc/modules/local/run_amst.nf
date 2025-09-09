process AMST {
    label 'amst'
    input:
    val(done)
    path(yaml_file)


    output:
    path("amst-transforms"), emit: transform_json
    path("elastix-params-amst-gs256.txt"), emit: elastix_params
    path "completion.txt", emit: done

    script:
    """
    run_amst.py  --input_yaml $yaml_file --out_json .
    echo "done" > completion.txt
    """
}
