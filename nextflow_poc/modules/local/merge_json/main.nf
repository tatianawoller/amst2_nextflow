process MERGE_JSON {
    label 'process_single'
    input:
    path(json_files)
    val(output_name)

    output:
    path("${output_name}", emit: json_merge)

    script:
    def sorted_files = json_files.sort { file ->
        def matcher = file.name =~ /(\d+)_(\d+)/
        matcher ? matcher[0][1].toInteger() : 0
    }
    def file_list = "'${sorted_files.collect{ it.name }.join(',')}'"
    """
    merge_json.py --json_list $file_list --json_file $output_name

    """
    stub:
    """
    touch $output_name
    """

}
