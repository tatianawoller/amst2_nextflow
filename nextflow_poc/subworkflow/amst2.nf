include {AMST2_PREALIGN as PREALIGN} from './../modules/amst2_prealign.nf'
include {AMST2_AMST as AMST} from './../modules/amst2_amst.nf'

workflow AMST2 {
    take:
        yaml_prealign
        yaml_amst
        workers 

    main: 
        PREALIGN(yaml_prealign,workers)
        AMST(yaml_amst,  PREALIGN.out.prealign_dir, workers)
    emit:
        prealigned_files=PREALIGN.out.prealign_dir
        amst_files= AMST.out.amst_tiffs
        done = AMST.out.done

}
