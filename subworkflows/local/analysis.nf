include { PVAL_PERMUTATIONS     }   from   '../../modules/local/pval_permutations'
include { FIND_SPLIZ_SITES      }   from   '../../modules/local/find_spliz_sites'
include { SUMMARIZE_RESULTS     }   from   '../../modules/local/summarize_results'

workflow ANALYSIS {
    take:
    splizvd_tsv
    splizvd_pq
    param_stem
    geneMat_samplesheet

    main:
    // Step 1: Calculate variance adjusted permutations
    PVAL_PERMUTATIONS (
        splizvd_pq,
        param_stem,
        params.dataname,
        params.n_perms,
        params.grouping_level_2,
        params.grouping_level_1
    )

    PVAL_PERMUTATIONS.out.perm_pvals
        .set{ pval_permutations }

    // Step 2: Find SpliZ sites
    FIND_SPLIZ_SITES (
        pval_permutations,
        params.libraryType,
        geneMat_samplesheet
    )

    // Step 3: Summarize results
    SUMMARIZE_RESULTS (
        pval_permutations,
        param_stem, 
        params.dataname,
        FIND_SPLIZ_SITES.out.first_evec,
        FIND_SPLIZ_SITES.out.second_evec,
        FIND_SPLIZ_SITES.out.third_evec,
        splizvd_tsv,
        params.grouping_level_2,
        params.grouping_level_1
    )
}
