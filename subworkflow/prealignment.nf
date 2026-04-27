include {ELASTIX_STACK_ALIGNMENT as sbs_alignment} from './../modules/local/sq_stack_alignment/main.nf'
include {ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_sbs_alignment; ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_nsbs_alignment}  from './../modules/local/sq_apply_multi_stack_alignment/main.nf'
include {ELASTIX_STACK_ALIGNMENT_2 as nsbs_alignment} from './../modules/local/sq_stack_alignment2/main.nf'
include{LINALG_OP as lin_alg_op} from './../modules/local/sq_matrices_op/main.nf'

workflow AMST2_PREALIGN {
    take:
        input
        out_json_sbs
        folder_sbs
        out_json_nsbs
        folder_nsbs
        json_prealigned

    main:
        sbs_alignment([input, out_json_sbs])
        input_sbs_align= sbs_alignment.out.json_transform.map { json_path ->
            tuple(input, json_path, folder_sbs)
        }
        apply_sbs_alignment(input_sbs_align)
        nsbs_alignment(apply_sbs_alignment.out.aligned.combine(channel.value(out_json_nsbs)))
        lin_alg_op(sbs_alignment.out.json_transform
            .combine(nsbs_alignment.out.json_transform)
            .combine(channel.value(json_prealigned)))
        input_nsbs_align= lin_alg_op.out.json_transform.map { json_path ->
            tuple(input, json_path, folder_nsbs)
        }
       apply_nsbs_alignment(input_nsbs_align) 
            
    emit: 
        prealigned=apply_nsbs_alignment.out.aligned

}
