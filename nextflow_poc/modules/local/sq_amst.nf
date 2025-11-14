process SQ_AMST {
    label 'sq_amst'  
    input:
    path(input_folder)
    val(json_name)
    val(elastix_default_params)

 

    output:
    path("*.json"), emit: json_transform

    script:
    def args = task.ext.args ?: ''
    """
    sq-elastix-amst $input_folder $json_name --elastix_parameter_file $elastix_default_params   $args
    """

}
