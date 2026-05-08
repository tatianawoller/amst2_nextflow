process MERGE_JSON {
    label 'process_single'
    input:
    path(input_dir)
    val(json_file)

    output:
    path("*.json", emit: json_merge)

    script:
    def file_list = "'${input_dir.collect{ it.name }.join(',')}'"
    """
    merge_json.py --json_list $file_list --json_file $json_file

    """
    stub:
    """
    touch $json_file
    """

}
