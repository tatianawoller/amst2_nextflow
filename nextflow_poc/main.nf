#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {ELASTIX_STACK_ALIGNMENT_SBS as sbs_alignment} from './modules/local/stack_alignment_sbs.nf'
include {APPLY_ELASTIX_ALIGNMENT as apply_sbs_alignment} from './modules/local/apply_align.nf'
include {ELASTIX_STACK_ALIGNMENT_NBS as nbs_alignment} from './modules/local/stack_alignment_nbs.nf'
include {APPLY_ELASTIX_PREALIGNMENT as prealignment} from './modules/local/apply_prealign.nf'
include {AMST as amst} from './modules/local/run_amst.nf'
include {APPLY_AMST as apply_amst} from './modules/local/apply_amst.nf'


workflow {
    sbs_alignment(params.yaml_prealign, "sbs_alignment")
    apply_sbs_alignment(params.yaml_prealign, "sbs_alignment", sbs_alignment.out.json_transform)
    nbs_alignment(apply_sbs_alignment.out.done,params.output_sbs, params.yaml_prealign, "nsbs_alignment")
    prealignment(params.yaml_prealign,  sbs_alignment.out.json_transform, nbs_alignment.out.json_transform)
    amst(prealignment.out.done,params.yaml_amst)
    apply_amst(params.yaml_amst, amst.out.transform_json)

}

