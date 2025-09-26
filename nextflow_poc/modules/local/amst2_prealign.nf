process AMST2_PREALIGN {
    label 'AMST2_prealign'
    container '/dodrio/scratch/projects/2024_300/twoller/containers_EM/squirrel.sif'    
    input:
    path(yaml_file)
    val(workers)

    output:
    //path("*.json"), emit: json_transform
    path("prealigned"), emit: prealign_dir
    path "completion_prealign.txt", emit: done

    script:
    """
    amst2_prealign.py  --input $yaml_file --out_dir . --workers $workers
    echo "done" > completion_prealign.txt
    """

}
