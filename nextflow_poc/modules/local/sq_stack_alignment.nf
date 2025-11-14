process ELASTIX_STACK_ALIGNMENT {
    label 'elastix_stack_alignment'  
    input:
    path(input)
    val(json_name)
    val(z_step)

 

    output:
    path("*.json"), emit: json_transform

    script:
    def args = task.ext.args ?: ''
    """
    sq-elastix-stack_alignment  $input $json_name --z_step $z_step $args

    """

}
