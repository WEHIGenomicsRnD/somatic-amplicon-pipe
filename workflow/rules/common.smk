import os
import yaml
from glob import iglob


# ------------- load cluster config ------------

with open("config/cluster.yaml", "r") as stream:
    try:
        cluster = yaml.safe_load(stream)
    except yaml.YAMLError as exc:
        print(exc, file=sys.stderr)

refdir = os.path.dirname(config["ref"])

# ------------- set up samples ------------

# in this case, we expect the fastq files to already exist
bams = iglob(f"mapped/*.bam")

# extract basename of full file path
samples = [os.path.basename(i).split(".bam")[0] for i in bams]

# ------------- input/output functions ------------


def get_variant_call_output():
    varcall_output = expand("results/variants/{sample}.genome.vcf", sample=samples)
    return varcall_output
