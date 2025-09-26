#!/usr/bin/env nextflow
include {AMST2} from './subworkflows/amst2.nf'
include {PREPARE_DATA} from './modules/prepare.nf'  
include {CAREAMICS} from './subworkflows/careamics.nf'


workflow {
    AMST2(params.yaml_prealign, params.yaml_amst, params.workers)
    PREPARE_DATA(AMST2.out.amst_files,
                params.file_extension,
                params.n_training_crops,
                params.n_validation_crops,
                params.crop_size,
                params.max_zero_fraction,
                params.outdir)
    CAREAMICS(AMST2.out.amst_files,
                PREPARE_DATA.out.csv,
                params.model,
                params.exp_name,
                params.batch_size,
                params.patch_size,
                params.num_epochs,
                params.axes,
                params.file_extension,
                params.tile_size,
                params.tile_overlap,
                params.test_axis)

}
