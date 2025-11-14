include {ELASTIX_STACK_ALIGNMENT as sbs_alignment} from './../modules/local/sq_stack_alignment.nf'
include {ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_sbs_alignment; ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_nsbs_alignment}  from './../modules/local/sq_apply_multi_stack_alignment.nf'
include {ELASTIX_STACK_ALIGNMENT_2 as nsbs_alignment} from './../modules/local/sq_stack_alignment_2.nf'
include{LINALG_OP as lin_alg_op} from './../modules/local/sq_matrices_op.nf'

workflow AMST2_PREALIGN {
    take:
        input
        out_json0
        z_step0
        folder_sbs
        out_json1
        z_step1
        json2
        json3
        json4
        keepmeta 
        folder_nsbs

    main:
        sbs_alignment(input, out_json0, z_step0)
        apply_sbs_alignment(input, sbs_alignment.out.json_transform,folder_sbs)
        nsbs_alignment(apply_sbs_alignment.out.sbs_align,out_json1, z_step1)
        lin_alg_op(sbs_alignment.out.json_transform, nsbs_alignment.out.json_transform, json2, json3, json4, keepmeta)
        apply_nsbs_alignment(input, lin_alg_op.out.json_transform,folder_nsbs) 
            
    emit: 
        prealigned=apply_nsbs_alignment.out.sbs_align

}