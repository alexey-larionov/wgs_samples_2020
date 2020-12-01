#!/bin/bash

# s03_extract_vcf_header_and_some_records_IHCAPX8.sh
# Alexey Larionov, 01Dec2020

# Use:
# sbatch s03_extract_vcf_header_and_some_records_IHCAPX8.sh

#SBATCH -J s03_extract_vcf_header_and_some_records_IHCAPX8
#SBATCH -A TISCHKOWITZ-SL2-CPU
#SBATCH -p skylake
#SBATCH --mail-type=ALL
#SBATCH --no-requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=01:00:00
#SBATCH --output=s03_extract_vcf_header_and_some_records_IHCAPX8.log
#SBATCH --qos=INTR

## Modules section (required, do not remove)
. /etc/profile.d/modules.sh
module purge
module load rhel7/default-peta4

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

# Folders
base_folder="/rds/project/erf33/rds-erf33-medgen"
project_folder="${base_folder}/data/wgs_nov_2020"

scripts_folder="${project_folder}/s00_scripts/s04_explore_and_qc_short_variant_vcfs"
cd "${scripts_folder}"

source_folder="${project_folder}/s02_IHCAPX8/s04_explore_and_qc_short_variant_vcfs"
source_vcf="${source_folder}/IHCAPX8_short_variants_pf.vcf.gz"

output_folder="${project_folder}/s02_IHCAPX8/s04_explore_and_qc_short_variant_vcfs/s03_extracts_from_vcf"
rm -fr "${output_folder}" # remove folder if existed
mkdir -p "${output_folder}"

vcf_header="${output_folder}/IHCAPX8_short_variants_pf_header.txt"
vcf_extract="${output_folder}/IHCAPX8_short_variants_pf_extract.txt"

# Tools (python3 includes mathplotlib etc by default)
tools_folder="${base_folder}/tools"
bcftools_bin="${tools_folder}/bcftools/bcftools-1.10.2/bin"
export PATH="${bcftools_bin}:$PATH"

# Progress report
echo "source_vcf: ${source_vcf}"
echo "vcf_header: ${vcf_header}"
echo "vcf_extract: ${vcf_extract}"
echo ""

# Keep only PASS-ed variants
echo "Extracting header ..."
bcftools view "${source_vcf}" -h > "${vcf_header}"

echo "Extracting some variant records ..."
bcftools view "${source_vcf}" -H | head -n 100 > "${vcf_extract}"
echo "" >> "${vcf_extract}"
echo "..." >> "${vcf_extract}"
echo "" >> "${vcf_extract}"
bcftools view "${source_vcf}" -H | tail -n 100 >> "${vcf_extract}"
echo ""

# Completion message
echo "Done all tasks"
date
