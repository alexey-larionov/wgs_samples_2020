#!/bin/bash

# s15_download_dragen_joined_short_variants_IHCAPX8.sh
# Alexey Larionov, 29Nov2020

# Use:
# sbatch s15_download_dragen_joined_short_variants_IHCAPX8.sh

# Multi-sampe VCF for SNP-s and short INDEL-s
# the total size ~2GB, expected download time <10min

#SBATCH -J s15_download_dragen_joined_short_variants_IHCAPX8
#SBATCH -A TISCHKOWITZ-SL2-CPU
#SBATCH -p skylake
#SBATCH --mail-type=ALL
#SBATCH --no-requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --output=s15_download_dragen_joined_short_variants_IHCAPX8.log
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

echo "Download dataset from BaseSpace"
date
echo ""

# bs (authenticated interactively before writing this script)
bs="/rds/project/erf33/rds-erf33-medgen/tools/bs/bs_cli_1.2.1/bs"

# Project and analysis in basespace (identified interactively before running this script)
project_name="IHCAPX8"
filter_field="AppSession.Name"
filter_term="Dragen Joint Genotyping Pipeline IHCAPX8 11/28/2020"

# Get dataset id
dataset_id=$($bs list datasets --filter-field="${filter_field}" --filter-term="${filter_term}" --field=Id --format=csv)

# Set folder for data
target_folder="/rds/project/erf33/rds-erf33-medgen/data/wgs_nov_2020/s02_IHCAPX8/s03_dragen_joined_genotyping/s01_short_variants"
mkdir -p "${target_folder}"
cd "${target_folder}"

# Report progress
echo "bs: ${bs}"
echo "project_name: ${project_name}"
echo "filter_field: ${filter_field}"
echo "filter_term: ${filter_term}"
echo "dataset_id: ${dataset_id}"
echo "target_folder: ${target_folder}"
echo ""

# Report bs credentials
echo "bs credentials:"
echo ""
"${bs}" whoami
echo ""

# List all datasets in the project
echo "All datasets in the project"
echo ""
$bs list datasets --filter-field="Project.Name" --filter-term="${project_name}"
echo ""

# Check content of the dataset
echo "Content of the selected dataset"
echo ""
$bs get dataset -i "${dataset_id}"
echo ""

# Download all files from the dataset
echo "Downloading data ..."
"${bs}" download dataset -i "${dataset_id}" -o "${target_folder}"

echo ""
echo "Done"
date
