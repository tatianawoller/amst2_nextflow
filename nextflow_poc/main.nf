#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {ELASTIX_STACK_ALIGNMENT as sbs_alignment} from './modules/local/stack_alignment.nf'

workflow {
sbs_alignment(params.yaml_prealign,"sbs_alignment", params.output_sbs)
//sbs_alignment.OUT.json_transform.view()
}

