process SQ_AMST {
    label 'process_high'
    container '/scratch/348/vsc34840/containers/squirrel_nextflow.sif'  
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
