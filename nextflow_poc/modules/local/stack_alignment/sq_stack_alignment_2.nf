process ELASTIX_STACK_ALIGNMENT_2 {
    label 'process_cpu_medium'  
    input: path(input_dir)
    tuple val(start), val(end)

    output:
    path "nsbs_${start}_${end}.json", emit: json_transform

    script:
    def args = task.ext.args ?: ''
    """
    sq-elastix-stack_alignment ${input_dir} nsbs_${start}_${end}.json \
        --z_range ${start} ${end} \
        --n_workers ${task.cpus} \
        $args

    """

}
