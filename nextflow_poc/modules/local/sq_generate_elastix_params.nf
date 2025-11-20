process SQ_GENERATE_ELASTIX {
    label 'process_single'  
    container '/scratch/348/vsc34840/containers/squirrel_nextflow.sif'  
    input:
    val(filename_elastix)
    val(transform)
    val(elx_params)

    output:
    path("elastix-params-amst-gs256.txt"), emit: elastix_default_params

    script:
    def args = task.ext.args ?: ''
    """
    sq-elastix-make_default_parameter_file $filename_elastix --transform $transform -elx $elx_params
    """

}
