process ELASTIX_STACK_ALIGNMENT_2 {
    label 'process_cpu_medium'  
    input: path(input_dir)
    tuple val(start), val(end)

    output:
    path "sbs_${start}_${end}.json", emit: json_transform

    script:
    def args = task.ext.args ?: ''
    """
    mkdir -p tif_folder
    cp ${input_dir} tif_folder/
    sq-elastix-stack_alignment tif_folder sbs_${start}_${end}.json \
        --z_range ${start} ${end} \
        --n_workers ${task.cpus} \
        $args

    """

}
