process AMST2_AMST {
    label 'AMST2_amst'
    container '//dodrio/scratch/projects/2024_300/twoller/containers_EM/squirrel.sif'
   // container '/home/tatiana/squirrel/squirrel_debug.sif' WSL
//    conda '/home/tatiana/miniconda3/envs/squirrel-env'    
    input:
    path(yaml_file)
    path(prealign_dir)
    val(workers)
 

    output:
    //path("amst-transforms"), emit: transform_json
    //path("elastix-params-amst-gs256.txt"), emit: elastix_params
    path("amst"), emit: amst_tiffs
    path "completion_amst.txt", emit: done

    script:
    """
    amst2_amst.py  --input $yaml_file --out_dir . --prealign_dir $prealign_dir --workers $workers
    echo "done" > completion_amst.txt
    """

}
