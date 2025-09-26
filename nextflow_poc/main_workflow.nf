#!/usr/bin/env nextflow
include {AMST2} from './subworkflows/amst2.nf'
include {PREPARE_DATA} from './modules/prepare.nf'  
//some denoising


workflow {
    AMST2(params.yaml_prealign, params.yaml_amst, params.workers)
    PREPARE_DATA(AMST2.out.amst_files,
                params.file_extension,
                params.n_training_crops,
                params.n_validation_crops,
                params.crop_size,
                params.max_zero_fraction,
                params.outdir)
    //some denoising

}
