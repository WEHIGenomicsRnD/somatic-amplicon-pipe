rule pisces:
    input:
        bam="results/realigned/{sample}.bam",
        bam_index="results/realigned/{sample}.bam.bai",
    output:
        vcf="results/variants/{sample}.genome.vcf",
    log:
        "logs/pisces/{sample}.log",
    envmodules:
        "dotnet/2.1.809",
    conda:
        "../envs/pisces.yaml"
    threads: 16
    resources:
        mem_mb=8192,
    params:
        refdir=refdir,
        minbq=config["minbq"],
        minmq=config["minmq"],
        minvf=config["minvf"],
        baselogname=lambda w, input: os.path.splitext(input[0])[0],
    shell:
        """
        pisces \
            -bam {input.bam} \
            -o results/variants \
            -g {params.refdir} \
            -t {threads} \
            --baselogname {params.baselogname} \
            --minbq {params.minbq} \
            --minmq {params.minmq} \
            --minvf {params.minvf} > {output.vcf}
        """
