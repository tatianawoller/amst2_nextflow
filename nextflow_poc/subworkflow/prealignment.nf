include {ELASTIX_STACK_ALIGNMENT_SBS as sbs_alignment} from './../modules/local/stack_alignment_sbs.nf'
include {ELASTIX_STACK_ALIGNMENT_NBS  as nbs_alignment} from './../modules/local/stack_alignment_nbs.nf'
include {APPLY_ELASTIX_ALIGNMENT as apply_sbs_alignment} from './../modules/local/apply_align.nf'
include {APPLY_ELASTIX_PREALIGNMENT as prealignment} from './../modules/local/apply_prealign.nf'

workflow PREALIGN {
    take:
        yaml_prealign 

    main: 
        sbs_alignment(yaml_prealign, "sbs_alignment")
        apply_sbs_alignment(yaml_prealign, "sbs_alignment", sbs_alignment.out.json_transform)
        nbs_alignment(apply_sbs_alignment.out.done,params.output_sbs, yaml_prealign, "nsbs_alignment")
        prealignment(yaml_prealign,  sbs_alignment.out.json_transform, nbs_alignment.out.json_transform)
            
    emit: 
        done = prealignment.out.done

}
