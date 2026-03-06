process MERGE_FOLDER {
    label 'process_single'
    input:
    path(input_dir)
    val(output_folder)

    output:
    path("${output_folder}", emit: full_out)

    script:
    def file_list = "'${input_dir.collect{ it.name }.join(',')}'"
    """
    merge_folder.py --folder_list $file_list --output_dir $output_folder

    """
    stub:
    """
    touch $json_file
    """

}
