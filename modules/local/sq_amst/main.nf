process SQ_AMST {
    //tag "$meta.id"
    label 'process_cpu_medium'  

    input:
  //  tuple val(meta),path(folder_aligned),val(transform_folder),path(elastix_params)
    tuple path(folder_aligned),val(transform_folder),path(elastix_params)
 

    output:
   // tuple val(meta),path(transform_folder), emit: json_transform
    path(transform_folder), emit: json_transform
    path "versions.yml"            , emit: versions

    when:
    task.ext.when == null || task.ext.when
    script:
    def args = task.ext.args ?: ''
    """
    sq-elastix-amst $folder_aligned $transform_folder --elastix_parameter_file $elastix_params --n_workers ${task.cpus}   $args
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        squirrel: \$(python -c "import squirrel; print(squirrel.__version__)")
    END_VERSIONS
    """
    stub:
    """
    mkdir -p transform_json

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        squirrel: \$(python -c "import squirrel; print(squirrel.__version__)")
    END_VERSION
    """

}
