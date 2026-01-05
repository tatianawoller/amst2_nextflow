process LINALG_OP {
    label 'process_single'
    input:
    path(input_json0)
    path(input_json1)
    val(json_4)

    output:
    path("prealigned.json", emit: json_transform)

    script:
    def args = task.ext.args ?: ''
    """
    sq-linalg-apply_z_step $input_json1 "nsbs_zstep1.json"
    sq-linalg-dot_product_on_affines $input_json0 "nsbs_zstep1.json" "combined.json" $args
    sq-transform-apply_auto_pad "combined.json" $json_4
    """
    stub:
    """
    touch prealigned.json
    """

}
