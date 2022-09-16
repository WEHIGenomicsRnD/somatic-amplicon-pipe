rule pisces:
    input:
        bam="results/realigned/{sample}.bam",
        bam_index="results/realigned/{sample}.bam.bai",
    output:
        vcf="results/variants/{sample}/{sample}.genome.vcf",
    log:
        "logs/pisces/{sample}.log",
    envmodules:
        "dotnet/2.1.809",
    conda:
        "../envs/pisces.yaml"
    threads: cluster["pisces"]["threads"]
    resources:
        mem_mb=cluster["pisces"]["mem_mb"],
        runtime=cluster["pisces"]["runtime"],
    params:
        refdir=refdir,
        minbq=config["minbq"],
        minmq=config["minmq"],
        minvf=config["minvf"],
        basename=lambda w, output: os.path.split(output[0])[0],
    shell:
        """
        pisces \
            -bam {input.bam} \
            -o {params.basename} \
            -g {params.refdir} \
            -t {threads} \
            --baselogname {params.basename} \
            --minbq {params.minbq} \
            --minmq {params.minmq} \
            --minvf {params.minvf}
        """
