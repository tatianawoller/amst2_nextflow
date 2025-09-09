include {AMST as amst} from './../modules/local/run_amst.nf'
include {APPLY_AMST as apply_amst} from './../modules/local/apply_amst.nf'

workflow AMST_WORKFLOW {
    take:
        done_signal
        yaml_amst

    main: 
        amst(done_signal,params.yaml_amst)
        apply_amst(yaml_amst, amst.out.transform_json)
    
        
    emit: 
        apply_amst.out.amst_tiffs
        apply_amst.out.done


}
