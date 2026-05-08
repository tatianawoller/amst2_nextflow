process ELASTIX_APPLY_MULTI_STACK_ALIGNMENT {
    label 'process_cpu_medium'  
    input:
    path(input)
    //path(input, name: "input_dir/*")
    val(json_name)
    val(align_folder)
    tuple val(start), val(end)
 

    output:
    path("${align_folder}${start}_${end}"), emit: tif_files

    script:
    def args = task.ext.args ?: ''
    """
    mkdir -p ${align_folder}${start}_${end}
    if [ -d "${input}" ]; then
       mkdir -p data_folder
       cp -r ${input}/* data_folder/
    else
       mkdir -p data_folder
       cp ${input} data_folder/

    fi
    sq-elastix-apply_multi_step_stack_alignment   data_folder $json_name ${align_folder}${start}_${end} --n_workers ${task.cpus} --z_range ${start} ${end} $args

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
