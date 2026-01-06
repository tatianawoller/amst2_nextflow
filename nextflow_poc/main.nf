#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {ELASTIX_STACK_ALIGNMENT as sbs_alignment} from './modules/local/stack_alignment/sq_stack_alignment.nf'
include {ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_sbs_alignment; ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_nsbs_alignment; ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_amst_alignment }  from './modules/local/apply_multi_stack_alignment/sq_apply_multi_stack_alignment.nf'
include {ELASTIX_STACK_ALIGNMENT_2 as nsbs_alignment} from './modules/local/stack_alignment/sq_stack_alignment_2.nf'
include{LINALG_OP as lin_alg_op} from './modules/local/matrices_op/sq_matrices_op.nf'
include {SQ_GENERATE_ELASTIX as generate_elastix_params} from './modules/local/generate_elx_params/sq_generate_elastix_params.nf'
include {SQ_AMST as amst} from './modules/local/amst/sq_amst.nf'



workflow {
     input_dir = file(params.input)
     def file_count = input_dir.list().size()
     def batch_size = 8
    
     ranges_ch = channel.of(0..<file_count)
        .collate(batch_size)
        .map { batch -> 
            def start = batch[0] + 1
            def end = batch[-1] + 1
            tuple(start, end)
        }
     sbs_alignment(input_dir,ranges_ch)
//    apply_sbs_alignment(params.input, sbs_alignment.out.json_transform,params.folder_sbs)
//    nsbs_alignment(apply_sbs_alignment.out.sbs_align,params.out_json1, params.z_step1)
//    lin_alg_op(sbs_alignment.out.json_transform, nsbs_alignment.out.json_transform, params.json4)
//    apply_nsbs_alignment(params.input, lin_alg_op.out.json_transform,params.folder_nsbs)
//    generate_elastix_params(params.default_elastix, params.transform_amst, params.elx)
//    amst(apply_nsbs_alignment.out.sbs_align,params.out_amst,generate_elastix_params.out.elastix_default_params)
//    apply_amst_alignment(apply_nsbs_alignment.out.sbs_align, amst.out.json_transform,params.folder_amst)
}
