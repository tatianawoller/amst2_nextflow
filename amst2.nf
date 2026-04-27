#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {AMST2_AMST} from './subworkflow/amst.nf'
include {AMST2_PREALIGN} from './subworkflow/prealignment.nf'


workflow {
    AMST2_PREALIGN(
        params.input,
        params.json_sbs,
        params.folder_sbs,
        params.json_nsbs, 
        params.folder_nsbs,
        params.json4)
    AMST2_AMST(
        params.default_elastix, 
        params.default_transform, 
        params.elx,
        AMST2_PREALIGN.out.prealigned,
        params.out_amst,
        params.folder_amst)

}
