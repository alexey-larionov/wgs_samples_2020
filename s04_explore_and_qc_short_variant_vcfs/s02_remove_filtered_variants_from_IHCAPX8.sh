#!/bin/bash

# s02_remove_filtered_variants_from_IHCAPX8.sh
# Alexey Larionov, 01Dec2020

# Use:
# sbatch s02_remove_filtered_variants_from_IHCAPX8.sh

#SBATCH -J s02_remove_filtered_variants_from_IHCAPX8
#SBATCH -A TISCHKOWITZ-SL2-CPU
#SBATCH -p skylake
#SBATCH --mail-type=ALL
#SBATCH --no-requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=01:00:00
#SBATCH --output=s02_remove_filtered_variants_from_IHCAPX8.log
#SBATCH --qos=INTR

## Modules section (required, do not remove)
. /etc/profile.d/modules.sh
module purge
module load rhel7/default-peta4
module load texlive/2015 # for pdf output in bcfstats

## Set initial working folder
cd "${SLURM_SUBMIT_DIR}"

## Report settings and run the job
echo "Job id: ${SLURM_JOB_ID}"
echo "Allocated node: $(hostname)"
echo "$(date)"
echo ""
echo "Job name: ${SLURM_JOB_NAME}"
echo ""
echo "Initial working folder:"
echo "${SLURM_SUBMIT_DIR}"
echo ""
echo " ------------------ Job progress ------------------ "
echo ""

# Stop at runtime errors
set -e

# Start message
echo "Remove filtered variants from IHCAPX8 hard filters"
echo "and calculate stats after the removal"
date
echo ""

# Files and folders
base_folder="/rds/project/erf33/rds-erf33-medgen"
project_folder="${base_folder}/data/wgs_nov_2020"

scripts_folder="${project_folder}/s00_scripts/s04_explore_and_qc_short_variant_vcfs"
cd "${scripts_folder}"

source_folder="${project_folder}/s02_IHCAPX8/s03_dragen_joined_genotyping/s01_short_variants"
source_vcf="${source_folder}/IHCAPX8_dragen_joint.hard-filtered.vcf.gz"

output_folder="${project_folder}/s02_IHCAPX8/s04_explore_and_qc_short_variant_vcfs"
output_vcf="${output_folder}/IHCAPX8_short_variants_pf.vcf.gz"

stats_folder="${project_folder}/s02_IHCAPX8/s04_explore_and_qc_short_variant_vcfs/s02_bcfstats_filtered"
rm -fr "${stats_folder}" # remove folder if existed
mkdir -p "${stats_folder}"
stats_file="${stats_folder}/bcfstats.vchk"

# Tools (python3 includes mathplotlib etc by default)
tools_folder="${base_folder}/tools"
bcftools_bin="${tools_folder}/bcftools/bcftools-1.10.2/bin"
python_bin="${tools_folder}/python/python_3.8.3/bin"
export PATH="${bcftools_bin}:${python_bin}:$PATH"

# Progress report
echo "source_vcf: ${source_vcf}"
echo "output_vcf: ${output_vcf}"
echo ""

echo "Counts in source VCF"
echo ""
bcftools +counts  "${source_vcf}"
echo ""

echo "FILTER column in source VCF"
echo ""
bcftools query -f '%FILTER\n' "${source_vcf}" | sort |  uniq -c | sort -nr
echo ""

# Keep only PASS-ed variants
echo "Filtering ..."
echo ""
bcftools view "${source_vcf}" \
--apply-filters 'PASS' \
--output-file "${output_vcf}" \
--output-type z
#--threads 4

bcftools index "${output_vcf}"

echo "Counts in output VCF"
echo ""
bcftools +counts  "${output_vcf}"
echo ""

echo "FILTER column in output VCF"
echo ""
bcftools query -f '%FILTER\n' "${output_vcf}" | sort |  uniq -c | sort -nr
echo ""

# bcf stats in output VCF
echo "Calculating stats for output VCF ..."
bcftools stats -s- "${output_vcf}" > "${stats_file}"

# Plot the stats ( PDF requires texlive)
echo "Making plots..."
plot-vcfstats -p "${stats_folder}" "${stats_file}"
echo ""

# Completion message
echo "Done all tasks"
date
