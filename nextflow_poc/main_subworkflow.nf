#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {AMST2_AMST} from './subworkflow/amst.nf'
include {AMST2_PREALIGN} from './subworkflow/prealignment.nf'


workflow {
    AMST2_PREALIGN(params.input, params.out_json0, params.z_step0,params.folder_sbs,params.out_json1, params.z_step1,params.json2, params.json3, params.json4, params.keepmeta,params.folder_nsbs)
    AMST2_AMST(params.default_elastix, params.transform_amst, params.elx,AMST2_PREALIGN.out.prealigned,params.out_amst,params.folder_amst)

}
