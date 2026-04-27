process ELASTIX_APPLY_MULTI_STACK_ALIGNMENT {
    label 'process_cpu_medium'  
    //tag "$meta.id"

    input:
//  tuple val(meta), path(input_path), path(json_transform), val(align_folder)
    tuple path(input_path), path(json_transform), val(align_folder)
    output:
    path(align_folder), emit: aligned
    path "versions.yml"             , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    //def args = task.ext.args ?: ''
    """
    mkdir -p ${align_folder}
        sq-elastix-apply_multi_step_stack_alignment \\
        $input_path \\
        $json_transform \\
        $align_folder \\
        --n_workers ${task.cpus} \\
        

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        squirrel: \$(python -c "import squirrel; print(squirrel.__version__)")
    END_VERSIONS

    """
    stub:
   // def prefix = task.ext.prefix ?: "${meta.id}"
   // a remettre dans le bash mkdir -p ${prefix}_align et  touch ${prefix}_align/dummy.tif
    """
    mkdir -p sbs_align
    touch sbs_align/dummy.tif

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        squirrel: \$(python -c "import squirrel; print(squirrel.__version__)")
    END_VERSIONS
    """

}
