process ELASTIX_STACK_ALIGNMENT {
    label 'process_cpu_medium'  
    input: path(input_dir)
    tuple val(start), val(end)

    output:
    path "sbs_${start}_${end}.json", emit: json_transform

    script:
    def args = task.ext.args ?: ''
    """
     sq-elastix-stack_alignment ${input_dir} sbs_${start}_${end}.json \
        --z_range ${start} ${end} \
        --n_workers ${task.cpus} \
        $args
 
    """
    stub:
    """
    touch test.json
    """

}
