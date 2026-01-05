include {ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_amst_alignment }  from './../modules/local/apply_multi_stack_alignment/sq_apply_multi_stack_alignment.nf'
include {SQ_GENERATE_ELASTIX as generate_elastix_params} from './../modules/local/generate_elx_params/sq_generate_elastix_params.nf'
include {SQ_AMST as amst} from './../modules/local/amst/sq_amst.nf'

workflow AMST2_AMST {
    take:
        default_elastix
        transform_amst
        elx
        out_prealigned
        out_amst
        folder_amst

    main: 
        generate_elastix_params(default_elastix, transform_amst, elx)
        amst(out_prealigned,out_amst,generate_elastix_params.out.elastix_default_params)
        apply_amst_alignment(out_prealigned, amst.out.json_transform,folder_amst)
    
        
    emit: 
        apply_amst_alignment.out.sbs_align

}