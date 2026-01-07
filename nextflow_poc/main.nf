#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {ELASTIX_STACK_ALIGNMENT as sbs_alignment} from './modules/local/stack_alignment/sq_stack_alignment.nf'
include {ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_sbs_alignment; ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_nsbs_alignment; ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_amst_alignment }  from './modules/local/apply_multi_stack_alignment/sq_apply_multi_stack_alignment.nf'
include {ELASTIX_STACK_ALIGNMENT_2 as nsbs_alignment} from './modules/local/stack_alignment/sq_stack_alignment_2.nf'
include{LINALG_OP as lin_alg_op} from './modules/local/matrices_op/sq_matrices_op.nf'
include {SQ_GENERATE_ELASTIX as generate_elastix_params} from './modules/local/generate_elx_params/sq_generate_elastix_params.nf'
include {SQ_AMST as amst} from './modules/local/amst/sq_amst.nf'
include {MERGE_JSON as merge_json_sbs; MERGE_JSON as merge_json_nsbs; MERGE_JSON as merge_json_amst } from './modules/local/merge_json/main.nf'



workflow {
     input_dir = file(params.input)
     def file_count = input_dir.list().size()
     def batch_size = params.batch_size
    
     ranges_ch = channel.of(0..<file_count)
        .collate(batch_size)
        .map { batch -> 
            def start = batch[0] + 1
            def end = batch[-1] + 2
            tuple(start, end)
        }
     sbs_alignment(input_dir,ranges_ch)
     merge_json_sbs(sbs_alignment.out.json_transform.collect(),'sbs.json')
     apply_sbs_alignment(params.input, merge_json_sbs.out.json_merge,params.folder_sbs,ranges_ch)
     nsbs_alignment(apply_sbs_alignment.out.tif_files.collect(),ranges_ch)
     merge_json_nsbs(nsbs_alignment.out.json_transform.collect(),'nsbs.json')
     lin_alg_op(merge_json_sbs.out.json_merge, merge_json_nsbs.out.json_merge, params.json4)
     apply_nsbs_alignment(params.input, lin_alg_op.out.json_transform,params.folder_nsbs,ranges_ch)
     generate_elastix_params(params.default_elastix, params.transform_amst, params.elx)
     amst(apply_nsbs_alignment.out.tif_files.collect(),params.out_amst,generate_elastix_params.out.elastix_default_params,ranges_ch)
     // from here on it fails
     merge_json_amst(amst.out.json_transform.collect(),'amst_json')
     apply_amst_alignment(apply_nsbs_alignment.out.tif_files.collect(), merge_json_amst.out.json_merge,params.folder_amst,ranges_ch)
}
