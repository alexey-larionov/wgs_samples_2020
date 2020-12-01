#!/bin/bash

# s04_renaming_samples_ST349.sh
# Alexey Larionov, 27Nov2020

# Use:
# sbatch s04_renaming_samples_ST349.sh

#SBATCH -J s04_renaming_samples_ST349
#SBATCH -A TISCHKOWITZ-SL2-CPU
#SBATCH -p skylake
#SBATCH --mail-type=ALL
#SBATCH --no-requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=01:00:00
#SBATCH --output=s04_renaming_samples_ST349.log
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
working_folder="/rds/project/erf33/rds-erf33-medgen/data/wgs_nov_2020/s02_fastq/ST349"
cd "${working_folder}"

# --- Check md5 sums --- #

echo "Checking md5 sums"
echo ""

samples="ST349-202 ST349-252 ST349-301 ST349-302 ST349-303"
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
