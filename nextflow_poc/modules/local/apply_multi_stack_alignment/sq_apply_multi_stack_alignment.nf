process ELASTIX_APPLY_MULTI_STACK_ALIGNMENT {
    label 'process_cpu_medium'  
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
    sq-elastix-apply_multi_step_stack_alignment   $input $json_name $align_folder --n_workers ${task.cpus} $args

    """
    stub:
    """
    mkdir -p ${align_folder}
    cd ${align_folder}
    for i in {0..31}; do
        printf -v filename "slice_%04d.tif" \$i
        touch "\$filename"
        echo "Created \$filename"
    done
    """

}
