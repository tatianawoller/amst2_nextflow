process SQ_GENERATE_ELASTIX {
    label 'process_single'  

    input:
    tuple val(filename_elastix),val(transform), val(elx_params)

    output:
    path("elastix-params-amst-gs256.txt"), emit: elastix_default_params
    path "versions.yml"      , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    sq-elastix-make_default_parameter_file $filename_elastix --transform $transform -elx $elx_params  $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        squirrel: \$(python -c "import squirrel; print(squirrel.__version__)")
    END_VERSIONS
    """
    stub:
    """
    touch elastix-params-amst-gs256.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        squirrel: \$(python -c "import squirrel; print(squirrel.__version__)")
    END_VERSIONS
    """
}
