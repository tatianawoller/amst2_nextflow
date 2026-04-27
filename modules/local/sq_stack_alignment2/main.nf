process ELASTIX_STACK_ALIGNMENT_2 {
   // tag "$meta.id"
    label 'process_cpu_medium'

    input:
   // tuple val(meta), path(aligned_images), val(json_name)
    tuple path(aligned_images), val(json_name)

    output:
    //tuple val(meta), path("*.json"), emit: json_transform
    path("*.json"), emit: json_transform
    path "versions.yml"            , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    sq-elastix-stack_alignment \\
        $aligned_images \\
        $json_name \\
        --n_workers ${task.cpus} \\
        $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        squirrel: \$(python -c "import squirrel; print(squirrel.__version__)")
    END_VERSIONS
    """

    stub:
    //def prefix = task.ext.prefix ?: "${meta.id}"
    //touch ${prefix}_2.json
    """
    touch nsbs.json

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        squirrel: \$(python -c "import squirrel; print(squirrel.__version__)")
    END_VERSIONS
    """
}