process LINALG_OP{
    label 'lin_alg_op'
    input:
    path(input_json0)
    path(input_json1)
    val(json_2)
    val(json_3)
    val(json_4)
    val(keepmeta)

 

    output:
    path("prealigned.json", emit: json_transform)

    script:
    """
    sq-linalg-apply_z_step $input_json1 $json_2
    sq-linalg-dot_product_on_affines $input_json0 $json_2 $json_3 --keep_meta $keepmeta
    sq-transform-apply_auto_pad $json_3 $json_4
    """

}
