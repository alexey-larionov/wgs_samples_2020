#!/bin/bash

# download_wgs_data.sh
# Alexey Larionov, 11Nov2020

# Use:
# sbatch download_wgs_data.sh

# HiSeq4000, the total size ~348Gb

#SBATCH -J download_wgs_data
#SBATCH -A TISCHKOWITZ-SL2-CPU
#SBATCH -p skylake
#SBATCH --mail-type=ALL
#SBATCH --no-requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=10:00:00
#SBATCH --output=download_wgs_data.log

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

echo "Downloading WGS data"
date
echo ""

cd /rds/project/erf33/rds-erf33-medgen/data/wgs_Nov2020

wget --no-verbose --user <user> --password <password> http://sunstrider.medgen.medschl.cam.ac.uk/alarionov/20201027_WGS_alarionov.tar.gz.md5
echo ""

wget --no-verbose --user <user> --password <psssword> http://sunstrider.medgen.medschl.cam.ac.uk/alarionov/20201027_WGS_alarionov.tar.gz
echo ""

echo "Done"
date
