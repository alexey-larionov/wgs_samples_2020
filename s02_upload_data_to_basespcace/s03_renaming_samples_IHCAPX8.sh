#!/bin/bash

# s03_renaming_samples_IHCAPX8.sh
# Alexey Larionov, 27Nov2020

# Use:
# sbatch s03_renaming_samples_IHCAPX8.sh

#SBATCH -J s03_renaming_samples_IHCAPX8
#SBATCH -A TISCHKOWITZ-SL2-CPU
#SBATCH -p skylake
#SBATCH --mail-type=ALL
#SBATCH --no-requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=01:00:00
#SBATCH --output=s03_renaming_samples_IHCAPX8.log
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

echo "Rename files to fit BaseSpace requirements"
date
echo ""

# Working folder
working_folder="/rds/project/erf33/rds-erf33-medgen/data/wgs_nov_2020/s02_fastq/IHCAPX8"
cd "${working_folder}"

# --- Check md5 sums --- #

echo "Checking md5 sums"
echo ""

samples="IHCAPX8-1 IHCAPX8-2 IHCAPX8-3"
for sample in ${samples}
do
  echo ${sample}
  echo ""
  cd "${working_folder}/${sample}"
  md5sum -c MD5.txt
  echo ""
done

# --- Rename files --- #

echo "Renaming files"
echo ""

cd "${working_folder}"

# Instructions for renaming files
renaming_instructions="${working_folder}/renaming_samples.txt"

# For each line in the file with renaming instructions
while read sample original_file_name new_file_name
do

  # Rename
  cd "${working_folder}/${sample}"
  mv "${original_file_name}" "${new_file_name}"

  # Report
  echo "${sample}: ${original_file_name} -> ${new_file_name}"

done < "${renaming_instructions}" # Next file

# Completion message
echo ""
echo "Done"
date
