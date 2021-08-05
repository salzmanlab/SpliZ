process CALC_SPLIZVD {
    tag "${params.dataname}"
    publishDir "${params.outdir}/SpliZ_values",  
        mode: "copy", 
        pattern: "*.tsv"
    publishDir "${params.outdir}/SpliZ_values",  
        mode: "copy", 
        pattern: "*.pq"
    publishDir "${params.outdir}/logs", 
        mode: 'copy', 
        pattern: '*.log'
    
    input:
    path input
    val param_stem
    val dataname
    val pin_S
    val pin_z
    val bounds
    val svd_type
    val grouping_level_1
    val grouping_level_2
    val isLight
    val isSICILIAN
    val convert_parquet

    output:
    path outname_pq     , emit: pq
    path outname_tsv    , emit: tsv                                 
    path "*.geneMat"    , emit: geneMats
    path "*.log"        , emit: log                                    

    script:
    outname_pq          = "${dataname}_sym_SVD_${svd_type}_${param_stem}.pq"
    outname_tsv         = "${dataname}_sym_SVD_${svd_type}_${param_stem}_subcol.tsv"
    outname_log         = "calc_splizvd.log"
    if (convert_parquet == true):
        """
        calc_splizvd.py \\
            --input ${input} \\
            --pinning_S ${pin_S} \\
            --pinning_z ${pin_z} \\
            --lower_bound ${bounds} \\
            --isLight ${isLight} \\
            --isSICILIAN ${isSICILIAN} \\
            --grouping_level_2 ${grouping_level_2} \\
            --grouping_level_1 ${grouping_level_1} \\
            --outname_pq ${outname_pq} \\
            --outname_tsv ${outname_tsv} \\
            --outname_log ${outname_log} \\
            --convert_parquet
        """
    if (convert_parquet == false):
        """
        calc_splizvd.py \\
            --input ${input} \\
            --pinning_S ${pin_S} \\
            --pinning_z ${pin_z} \\
            --lower_bound ${bounds} \\
            --isLight ${isLight} \\
            --isSICILIAN ${isSICILIAN} \\
            --grouping_level_2 ${grouping_level_2} \\
            --grouping_level_1 ${grouping_level_1} \\
            --outname_pq ${outname_pq} \\
            --outname_tsv ${outname_tsv} \\
            --outname_log ${outname_log}
        """

} 