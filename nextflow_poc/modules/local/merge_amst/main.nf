process MERGE_AMST {
    label 'process_single'
    input:
    path(input_dir)
    val(out_dir)

    output:
    path("${out_dir}", emit: json_merge)

    script:
    def file_list = "'${input_dir.collect{ it.name }.join(',')}'"
    """
    merge_amst.py --file_list $file_list --outdir $out_dir
    """
    stub:
    """
    mkdir -p $out_dir
    """

}
