#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {ELASTIX_STACK_ALIGNMENT as sbs_alignment} from './modules/local/stack_alignment.nf'
include {APPLY_ELASTIX_ALIGNMENT as apply_sbs_alignment} from './modules/local/apply_align.nf'

workflow {
sbs_alignment(params.yaml_prealign,"sbs_alignment", params.output_sbs)
apply_sbs_alignment(params.yaml_prealign, "sbs_alignment",  sbs_alignment.out.json_transform)
}


