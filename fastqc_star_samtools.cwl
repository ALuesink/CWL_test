cwlVersion: v1.2
class: Workflow
label: RNAseq CWL practice workflow

inputs:
  fastq_file: File
  genome_dir: Directory

steps:
  quality_control:
    run: bio-cwl-tools/fastqc/fastqc_2.cwl
    in:
      reads_file: fastq_file
    out: [html_file]

  mapping_reads:
    requirements:
      ResourceRequirement:
        ramMin: 9000
    run: bio-cwl-tools/STAR/STAR-Align.cwl
    in:
      RunThreadN: {default: 4}
      GenomeDir: genome_dir
      ForwardReads: fastq_file
      OutSAMtype: {default: BAM}
      SortedByCoordinate: {default: true}
      OutSAMunmapped: {default: Within}
    out: [alignment]

  sorting_alignment:
    run: bio-cwl-tools/samtools/samtools_index.cwl
    in:
      bam_sorted: mapping_reads/alignment
    out: [bam_sorted_indexed]

outputs:
  qc_html:
    type: File
    outputSource: quality_control/html_file
  bam_sorted_indexed:
    type: File
    outputSource: sorting_alignment/bam_sorted_indexed
