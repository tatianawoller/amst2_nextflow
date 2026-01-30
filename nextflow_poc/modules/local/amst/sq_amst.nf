process SQ_AMST {
    label 'process_cpu_medium'  
    input:
    path(input_folder)
    val(json_name)
    val(elastix_default_params)
    tuple val(start), val(end)

    output:
    path "transform_${start}_${end}", emit: transform

    script:
    def args = task.ext.args ?: ''
    """
    mkdir -p tif_folder
    cp ${input_folder} tif_folder/
    sq-elastix-amst tif_folder transform_${start}_${end} --elastix_parameter_file $elastix_default_params --n_workers ${task.cpus} --z_range ${start} ${end}  $args
    """
    stub:
    """
    mkdir -p transform_json
    """

}
