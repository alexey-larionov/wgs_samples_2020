#!/bin/bash

# s13_download_dragen_gremline_ST349-302.sh
# Alexey Larionov, 29Nov2020

# Use:
# sbatch s13_download_dragen_gremline_ST349-302.sh

# Germline BAM and single-sampe VCF and gVCF files
# the total size ~50GB, expected download time ~30min

#SBATCH -J s13_download_dragen_gremline_ST349-302
#SBATCH -A TISCHKOWITZ-SL2-CPU
#SBATCH -p skylake
#SBATCH --mail-type=ALL
#SBATCH --no-requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --output=s13_download_dragen_gremline_ST349-302.log
##SBATCH --qos=INTR

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
project_name="ST349"
sample_name="ST349-302"
dataset_type="illumina.dragen.complete.v0.2"

# Get dataset id
dataset_id=$($bs list datasets --filter-field="Name" --filter-term="${sample_name}" --is-type="${dataset_type}" --field=Id --format=csv)

# Set folder for data
target_folder="/rds/project/erf33/rds-erf33-medgen/data/wgs_nov_2020/s04_ST349/s02_dragen_germline/ST349-302"
mkdir -p "${target_folder}"
cd "${target_folder}"

# Report progress
echo "bs: ${bs}"
echo "project_name: ${project_name}"
echo "sample_name: ${sample_name}"
echo "dataset_type: ${dataset_type}"
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
