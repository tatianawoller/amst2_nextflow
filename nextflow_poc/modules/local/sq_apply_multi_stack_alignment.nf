process ELASTIX_APPLY_MULTI_STACK_ALIGNMENT {
    label 'process_medium'
    container '/scratch/348/vsc34840/containers/squirrel_nextflow.sif'    
    input:
    path(input)
    val(json_name)
    val(align_folder)
 

    output:
    path(align_folder), emit: sbs_align

    script:
    def args = task.ext.args ?: ''
    """
    mkdir -p ${align_folder}
    sq-elastix-apply_multi_step_stack_alignment   $input $json_name $align_folder $args

    """

}
