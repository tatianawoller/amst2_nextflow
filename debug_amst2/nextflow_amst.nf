#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_amst_alignment }  from './modules/local/sq_apply_multi_stack_alignment.nf'
include {SQ_GENERATE_ELASTIX as generate_elastix_params} from './modules/local/sq_generate_elastix_params.nf'
include {SQ_AMST as amst} from './modules/local/sq_amst.nf'



workflow {
    generate_elastix_params(params.default_elastix, params.transform_default, params.elx)
    amst(params.aligned_taturtle,params.out_amst,generate_elastix_params.out.elastix_default_params)
    apply_amst_alignment(params.input_raw, amst.out.json_transform,params.folder_amst)
}
