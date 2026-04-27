include {ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_amst_alignment }  from './../modules/local/sq_apply_multi_stack_alignment/main.nf'
include {SQ_GENERATE_ELASTIX as generate_elastix_params} from './../modules/local/sq_generate_elastix/main.nf'
include {SQ_AMST as amst} from './../modules/local/sq_amst/main.nf'

workflow AMST2_AMST {
    take:
        default_elastix
        transform_amst
        elx
        out_prealigned
        out_amst
        folder_amst

    main: 
        generate_elastix_params(tuple(default_elastix, transform_amst, elx))
        input_amst=out_prealigned
            .combine(channel.value(out_amst))
            .combine(generate_elastix_params.out.elastix_default_params)
       // amst(out_prealigned,out_amst,generate_elastix_params.out.elastix_default_params)
        amst(input_amst)
        input_amst_align=out_prealigned
            .combine(amst.out.json_transform)
            .combine(channel.value(folder_amst))
       // apply_amst_alignment(out_prealigned, amst.out.json_transform,folder_amst)
       apply_amst_alignment(input_amst_align)
    
        
    emit: 
        apply_amst_alignment.out.aligned

}