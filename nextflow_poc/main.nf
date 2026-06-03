#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {ELASTIX_STACK_ALIGNMENT as sbs_alignment} from './modules/local/stack_alignment/sq_stack_alignment.nf'
include {ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_sbs_alignment; ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_nsbs_alignment; ELASTIX_APPLY_MULTI_STACK_ALIGNMENT as apply_amst_alignment }  from './modules/local/apply_multi_stack_alignment/sq_apply_multi_stack_alignment.nf'
include {ELASTIX_STACK_ALIGNMENT_2 as nsbs_alignment} from './modules/local/stack_alignment/sq_stack_alignment_2.nf'
include{LINALG_OP as lin_alg_op} from './modules/local/matrices_op/sq_matrices_op.nf'
include {SQ_GENERATE_ELASTIX as generate_elastix_params} from './modules/local/generate_elx_params/sq_generate_elastix_params.nf'
include {SQ_AMST as amst} from './modules/local/amst/sq_amst.nf'
include {MERGE_JSON as merge_json_sbs; MERGE_JSON as merge_json_nsbs} from './modules/local/merge_json/main.nf'
include {MERGE_AMST as merge_amst} from './modules/local/merge_amst/main.nf'
include {MERGE_FOLDER as merge_folder; MERGE_FOLDER as merge_folder_prealign; MERGE_FOLDER as merge_folder_amst } from './modules/local/merge_folder/main.nf'


workflow {
    input_dir = file(params.input)
    params_input2=params.input
    def file_count = input_dir.list().size()
    def batch_size = params.batch_size 
    
    // Calculate number of batches correctly
    def num_batches = Math.ceil(file_count / batch_size).intValue()
    
    // Create metadata-rich ranges channel with correct end calculation
    ranges_ch = channel.of(0..<num_batches)
        .map { batch_idx ->
            def start = batch_idx * batch_size
            def end = Math.min(start + batch_size, file_count )
            
            // Skip empty batches (shouldn't happen with correct calculation, but safety check)
            if (start >= file_count) {
                return null
            }
            
            def meta = [
                batch_id: batch_idx,
                start: start,
                end: end,
                range_str: "${start}_${end}",
                file_count: end - start
            ]
            [meta, start, end]
        }
        .filter { it != null }
        .view()
    sbs_alignment(input_dir, ranges_ch)

    ch_sbs_json_sorted = sbs_alignment.out.json_transform
        .toSortedList { a, b -> a[0].batch_id <=> b[0].batch_id }
        .map { sorted_list -> sorted_list.collect { _meta, file -> file } }
    
    merge_json_sbs(ch_sbs_json_sorted, 'sbs.json')
    
    ch_sbs_merged = merge_json_sbs.out.json_merge
    apply_sbs_alignment(params_input2, ch_sbs_merged, params.folder_sbs, ranges_ch)
    ch_sbs_folders_sorted = apply_sbs_alignment.out.tif_files
        .toSortedList { a, b -> a[0].batch_id <=> b[0].batch_id }
        .map { sorted_list -> sorted_list.collect { _meta, folder -> folder } }
    
    merge_folder(ch_sbs_folders_sorted, 'sbs_align')
   // merge_folder_sorted = merge_folder.out.full_out
  //  .toSortedList { a, b -> a.toString() <=> b.toString() }

    //nsbs_alignment(merge_folder_sorted, ranges_ch)

    //ch_nsbs_json_sorted = nsbs_alignment.out.json_transform
    //     .toSortedList { a, b -> a[0].batch_id <=> b[0].batch_id }
   //      .map { sorted_list -> sorted_list.collect { _meta, file -> file } }
    
   // merge_json_nsbs(ch_nsbs_json_sorted, 'nsbs.json')
  //  lin_alg_op(ch_sbs_merged, merge_json_nsbs.out.json_merge, params.json4)
   // ch_prealign_json = lin_alg_op.out.json_transform
   // input_dir.list().findAll{ it.isFile() }.sort{ it.getName() }
   // apply_nsbs_alignment(params.sorted_files, ch_prealign_json, params.folder_nsbs, ranges_ch)
   // ch_nsbs_folders_sorted = apply_nsbs_alignment.out.tif_files
   //      .toSortedList { a, b -> a[0].batch_id <=> b[0].batch_id }
   //      .map { sorted_list -> sorted_list.collect { _meta, folder -> folder } }
    
   // merge_folder_prealign(ch_nsbs_folders_sorted, 'nsbs_align')

 
    // // =========================================================================
    // // Step 6: Generate elastix params (runs once)
    // // =========================================================================
    // generate_elastix_params(params.default_elastix, params.transform_amst, params.elx)

    // // =========================================================================
    // // Step 7: AMST per batch on prealigned data
    // // =========================================================================
    // ch_prealigned_dir = merge_folder_prealign.out.full_out
    // ch_elastix_params = generate_elastix_params.out.elastix_default_params

    // amst(ch_prealigned_dir, params.out_amst, ch_elastix_params, ranges_ch)

    // // Collect AMST transform folders sorted by start index
    // ch_amst_transforms_sorted = amst.out.transform
    //     .toSortedList { a, b ->
    //         def aStart = (a.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
    //         def bStart = (b.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
    //         aStart <=> bStart
    //     }

    // merge_amst(ch_amst_transforms_sorted, 'amst_json')

    // // =========================================================================
    // // Step 8: Apply AMST alignment to all batches
    // // =========================================================================
    // ch_amst_merged = merge_amst.out.json_merge

    // apply_amst_alignment(ch_prealigned_dir, ch_amst_merged, params.folder_amst, ranges_ch)

    // // Collect AMST aligned folders sorted by start index
    // ch_amst_folders_sorted = apply_amst_alignment.out.tif_files
    //     .toSortedList { a, b ->
    //         def aStart = (a.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
    //         def bStart = (b.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
    //         aStart <=> bStart
    //     }

    // merge_folder_amst(ch_amst_folders_sorted, 'amst')
}
