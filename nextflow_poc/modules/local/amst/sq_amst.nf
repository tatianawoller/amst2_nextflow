process SQ_AMST {
    label 'process_cpu_medium'  
    input:
    path(input_folder)
    val(json_name)
    val(elastix_default_params)

 

    output:
    path(json_name), emit: json_transform

    script:
    def args = task.ext.args ?: ''
    """
    sq-elastix-amst $input_folder $json_name --elastix_parameter_file $elastix_default_params --n_workers ${task.cpus}   $args
    """
    stub:
    """
    mkdir -p transform_json
    """

}
