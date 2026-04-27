process ELASTIX_STACK_ALIGNMENT {
    label 'process_cpu_medium'  

    //conda "bioconda::squirrel=0.3.15"
    //container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
    //    'https://depot.galaxyproject.org/singularity/squirrel:0.3.15--pyhdfd78af_0':
    //    'biocontainers/squirrel:0.3.15--pyhdfd78af_0' }"

    input: 
    //tuple val(meta), path(input_path), val(json_name)
    tuple  path(input_path), val(json_name)

    output:
 //   tuple val(meta), path("*.json"), emit: json_transform
    path("*.json"), emit: json_transform
    path "versions.yml"            , emit: versions

    script:
    def args = task.ext.args ?: ''
    """
    sq-elastix-stack_alignment \\
        $input_path \\
        $json_name \\
        --n_workers ${task.cpus} \\
        $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        squirrel: \$(python -c "import squirrel; print(squirrel.__version__)")
    END_VERSIONS
    """

    stub:
  //  def prefix = task.ext.prefix ?: "${meta.id}"
  // a remettre dans le bash: touch ${prefix}.json
    """
    touch sbs.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        squirrel: \$(python -c "import squirrel; print(squirrel.__version__)")
    END_VERSIONS
    """
}
