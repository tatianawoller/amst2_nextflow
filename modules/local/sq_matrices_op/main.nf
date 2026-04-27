process LINALG_OP {
    label 'process_single'
    input:
   // tuple val(meta), path(json1), path(json2), val(output_json)
    tuple path(json1), path(json2), val(output_json)

    output:
    //tuple val(meta),path("prealigned.json"), emit: json_transform
    path("prealigned.json"), emit: json_transform
    path "versions.yml"            , emit: versions

    script:
    def args = task.ext.args ?: ''
    """
    sq-linalg-apply_z_step $json2 "nsbs_zstep1.json"
    sq-linalg-dot_product_on_affines $json1 "nsbs_zstep1.json" "combined.json" $args
    sq-transform-apply_auto_pad "combined.json" $output_json

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        squirrel: \$(python -c "import squirrel; print(squirrel.__version__)")
    END_VERSIONS
    """
    stub:
   // def prefix = task.ext.prefix ?: "${meta.id}"
   // a remettre dans le bash touch ${prefix}_combined.json
    """
    touch prealigned.json

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        squirrel: \$(python -c "import squirrel; print(squirrel.__version__)")
    END_VERSIONS
    """

}
