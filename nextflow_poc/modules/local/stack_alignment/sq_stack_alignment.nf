process ELASTIX_STACK_ALIGNMENT {
    label 'process_cpu_medium'  
    input: tuple path(input),val(json_name)

    output:
    path("*.json"), emit: json_transform

    script:
    def args = task.ext.args ?: ''
    """
    sq-elastix-stack_alignment  $input $json_name  --n_workers ${task.cpus} $args

    """
    stub:
    """
    touch test.json
    """

}
