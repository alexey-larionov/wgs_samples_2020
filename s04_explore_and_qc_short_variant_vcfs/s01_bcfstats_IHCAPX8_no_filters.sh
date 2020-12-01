#!/bin/bash

# s01_bcfstats_IHCAPX8_no_filters.sh.sh
# Alexey Larionov, 01Dec2020

# Use:
# sbatch s01_bcfstats_IHCAPX8_no_filters.sh.sh

# QC for joint IHCAPX8 w/o hard filters

#SBATCH -J s01_bcfstats_IHCAPX8_no_filters
#SBATCH -A TISCHKOWITZ-SL2-CPU
#SBATCH -p skylake
#SBATCH --mail-type=ALL
#SBATCH --no-requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=01:00:00
#SBATCH --output=s01_bcfstats_IHCAPX8_no_filters.log
#SBATCH --qos=INTR

## Modules section (required, do not remove)
. /etc/profile.d/modules.sh
module purge
module load rhel7/default-peta4
module load texlive/2015

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

echo "QC for joint IHCAPX8 w/o hard filters"
date
echo ""


# Folders
base_folder="/rds/project/erf33/rds-erf33-medgen"
project_folder="${base_folder}/data/wgs_nov_2020"

scripts_folder="${project_folder}/s00_scripts/s04_explore_and_qc_short_variant_vcfs"
cd "${scripts_folder}"

data_folder="${project_folder}/s02_IHCAPX8/s03_dragen_joined_genotyping/s01_short_variants"
vcf_file="${data_folder}/IHCAPX8_dragen_joint.vcf.gz"

stats_folder="${project_folder}/s02_IHCAPX8/s04_explore_and_qc_short_variant_vcfs/s01_bcfstats_no_filters"
rm -fr "${stats_folder}" # remove folder if existed
mkdir -p "${stats_folder}"
stats_file="${stats_folder}/bcfstats.vchk"

# Tools
tools_folder="${base_folder}/tools"
bcftools_bin="${tools_folder}/bcftools/bcftools-1.10.2/bin"
python_bin="${tools_folder}/python/python_3.8.3/bin"
export PATH="${bcftools_bin}:${python_bin}:$PATH"

# Progress report
echo "vcf_file: ${vcf_file}"
echo "stats_folder: ${stats_folder}"
echo ""

# Counts
echo "Calculating counts..."
echo ""
bcftools +counts "${vcf_file}"
echo ""

# Full vcf stats
echo "Calculating stats..."
bcftools stats -s- "${vcf_file}" > "${stats_file}"

# Plot the stats ( PDF requires texlive)
echo "Making plots..."
plot-vcfstats -p "${stats_folder}" "${stats_file}"
echo ""

# Progress report
echo "Done"
date
