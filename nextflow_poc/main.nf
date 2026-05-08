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
    def file_count = input_dir.list().size()
    def batch_size = params.batch_size

    // Create ranges channel - each emission is a tuple [start, end]
    ranges_ch = channel.of(0..<file_count)
        .collate(batch_size)
        .map { batch ->
            def start = batch[0]
            def end = batch[-1] + 1
            tuple(start, end)
        }

    // =========================================================================
    // Step 1: SBS alignment per batch -> produces sbs_<start>_<end>.json
    // =========================================================================
    sbs_alignment(input_dir, ranges_ch)

    // Collect JSON outputs sorted by start index to guarantee order
    // File names are sbs_<start>_<end>.json - sort by the start index
    ch_sbs_json_sorted = sbs_alignment.out.json_transform
        .toSortedList { a, b ->
            def aIdx = (a.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
            def bIdx = (b.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
            aIdx <=> bIdx
        }

    merge_json_sbs(ch_sbs_json_sorted, 'sbs.json')

    // =========================================================================
    // Step 2: Apply SBS alignment to all batches
    // merge_json_sbs receives only value-channel inputs, so its output is a
    // singleton (value channel) that naturally broadcasts to all ranges_ch items
    // =========================================================================
    ch_sbs_merged = merge_json_sbs.out.json_merge

    apply_sbs_alignment(params.input, ch_sbs_merged, params.folder_sbs, ranges_ch)

    // Collect folders sorted by start index
    ch_sbs_folders_sorted = apply_sbs_alignment.out.tif_files
        .toSortedList { a, b ->
            def aStart = (a.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
            def bStart = (b.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
            aStart <=> bStart
        }

    merge_folder(ch_sbs_folders_sorted, 'sbs_align')

    // =========================================================================
    // Step 3: NSBS alignment on merged SBS folder
    // merge_folder receives only value-channel inputs -> singleton output
    // =========================================================================
    ch_sbs_align_dir = merge_folder.out.full_out

    nsbs_alignment(ch_sbs_align_dir, ranges_ch)

    // Collect NSBS JSON outputs sorted by start index
    ch_nsbs_json_sorted = nsbs_alignment.out.json_transform
        .toSortedList { a, b ->
            def aIdx = (a.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
            def bIdx = (b.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
            aIdx <=> bIdx
        }

    merge_json_nsbs(ch_nsbs_json_sorted, 'nsbs.json')

    // =========================================================================
    // Step 4: Linear algebra op (combine SBS + NSBS transforms)
    // Both inputs are single-emission channels
    // =========================================================================
    lin_alg_op(ch_sbs_merged, merge_json_nsbs.out.json_merge, params.json4)

    // =========================================================================
    // Step 5: Apply NSBS (pre-alignment) to all batches
    // =========================================================================
    ch_prealign_json = lin_alg_op.out.json_transform

    apply_nsbs_alignment(params.input, ch_prealign_json, params.folder_nsbs, ranges_ch)

    // Collect prealign folders sorted by start index
    ch_nsbs_folders_sorted = apply_nsbs_alignment.out.tif_files
        .toSortedList { a, b ->
            def aStart = (a.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
            def bStart = (b.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
            aStart <=> bStart
        }

    merge_folder_prealign(ch_nsbs_folders_sorted, 'nsbs_align')

    // =========================================================================
    // Step 6: Generate elastix params (runs once)
    // =========================================================================
    generate_elastix_params(params.default_elastix, params.transform_amst, params.elx)

    // =========================================================================
    // Step 7: AMST per batch on prealigned data
    // =========================================================================
    ch_prealigned_dir = merge_folder_prealign.out.full_out
    ch_elastix_params = generate_elastix_params.out.elastix_default_params

    amst(ch_prealigned_dir, params.out_amst, ch_elastix_params, ranges_ch)

    // Collect AMST transform folders sorted by start index
    ch_amst_transforms_sorted = amst.out.transform
        .toSortedList { a, b ->
            def aStart = (a.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
            def bStart = (b.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
            aStart <=> bStart
        }

    merge_amst(ch_amst_transforms_sorted, 'amst_json')

    // =========================================================================
    // Step 8: Apply AMST alignment to all batches
    // =========================================================================
    ch_amst_merged = merge_amst.out.json_merge

    apply_amst_alignment(ch_prealigned_dir, ch_amst_merged, params.folder_amst, ranges_ch)

    // Collect AMST aligned folders sorted by start index
    ch_amst_folders_sorted = apply_amst_alignment.out.tif_files
        .toSortedList { a, b ->
            def aStart = (a.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
            def bStart = (b.name =~ /(\d+)_(\d+)/)[0][1].toInteger()
            aStart <=> bStart
        }

    merge_folder_amst(ch_amst_folders_sorted, 'amst')
}
