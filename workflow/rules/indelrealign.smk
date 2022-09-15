rule replace_rg:
    input:
        "mapped/{sample}.bam",
    output:
        "results/fixed-rg/{sample}.bam",
    log:
        "logs/picard/replace_rg/{sample}.log",
    params:
        extra="--RGLB lib1 --RGPL illumina --RGPU {sample} --RGSM {sample}",
    resources:
        mem_mb=32768,
    wrapper:
        "v1.12.2/bio/picard/addorreplacereadgroups"


rule samtools_index_rg:
    input:
        "results/fixed-rg/{sample}.bam",
    output:
        "results/fixed-rg/{sample}.bam.bai",
    log:
        "logs/samtools_index_rg/{sample}.log",
    params:
        extra="",
    threads: 16
    wrapper:
        "v1.12.2/bio/samtools/index"


rule indelrealigner:
    input:
        bam="results/fixed-rg/{sample}.bam",
        bam_index="results/fixed-rg/{sample}.bam.bai",
        ref=config["ref"],
        target_intervals=config["intervals"],
    output:
        bam="results/realigned/{sample}.bam",
    log:
        "logs/gatk3/indelrealigner/{sample}.log",
    params:
        extra="--maxReadsForRealignment 500000",
        java_opts="",
    threads: 16
    resources:
        mem_mb=8192,
    wrapper:
        "v1.12.2/bio/gatk3/indelrealigner"


rule samtools_index_ir:
    input:
        "results/realigned/{sample}.bam",
    output:
        "results/realigned/{sample}.bam.bai",
    log:
        "logs/samtools_index_ir/{sample}.log",
    params:
        extra="",
    threads: 16
    wrapper:
        "v1.12.2/bio/samtools/index"
