#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {AMST_WORKFLOW} from './subworkflow/amst.nf'
include {PREALIGN} from './subworkflow/prealignment.nf'


workflow {
    PREALIGN(params.yaml_prealign)
    AMST_WORKFLOW(PREALIGN.out.done,params.yaml_prealign)

}
