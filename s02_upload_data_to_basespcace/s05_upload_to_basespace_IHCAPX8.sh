#!/bin/bash

# s05_upload_to_basespace_IHCAPX8.sh
# Alexey Larionov, 27Nov2020

# Use:
# sbatch s05_upload_to_basespace_IHCAPX8.sh

# HiSeq4000: 18 FASTQ-s for 3 WGS PE samples, the total size ~150GB, expected upload time ~1.5hr

#SBATCH -J s05_upload_to_basespace_IHCAPX8
#SBATCH -A TISCHKOWITZ-SL2-CPU
#SBATCH -p skylake
#SBATCH --mail-type=ALL
#SBATCH --no-requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=3:00:00
#SBATCH --output=s05_upload_to_basespace_IHCAPX8.log
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

echo "Uploading WGS data to BaseSpace"
date
echo ""

# Authorised bs (authenticated interactively before running this script)
bs="/rds/project/erf33/rds-erf33-medgen/tools/bs/bs_cli_1.2.1/bs"

# Folder with data
data_folder="/rds/project/erf33/rds-erf33-medgen/data/wgs_nov_2020/s02_fastq/IHCAPX8"
cd "${data_folder}"

# Project ID and name (created interactively before running this script)
project_name="IHCAPX8"
project_id="213460248"

# Report progress
echo "bs: ${bs}"
echo "data_folder: ${data_folder}"
echo "project_name: ${project_name}"
echo "project_id: ${project_id}"
echo ""

# Report bs credentials
echo "bs credentials:"
echo ""
"${bs}" whoami

# Check bs projects
echo "Available projects on BaseSpace"
"${bs}" list projects

# Upload data (recursive: looking in sub-folders)
"${bs}" dataset upload -p "${project_id}" --recursive "${data_folder}"

echo ""
echo "Done"
date
