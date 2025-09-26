# Usage

- how to run
  ```bash
  module load Nextflow
  # run in local
  nextflow run main_subworkflow.nf -profile conda/apptainer
  # run on the cluster
  module load Nextflow
  nextflow run main_workflow.nf -c nextflow_EM.config
  ```
