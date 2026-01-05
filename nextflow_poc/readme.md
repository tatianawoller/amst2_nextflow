# Usage

- how to run
  ```bash
  module load Nextflow
  # run in local
  nextflow run main_subworkflow.nf -c nextflow_nf.config -profile conda_wsl/apptainer_wsl/docker_wsl
  # run on the cluster (i.e. from university using the nf-core config)
  module load Nextflow
  nextflow run main_workflow.nf -c nextflow_nf.config  - profile vsc_kul_uhasselt,genius,apptainer_tier2 --basepath .
  # run tests
  nf-test test --profile conda ./modules/local/amst/tests/main.nf.test
  ```
- nb: the vsc_kul_uhasselt can be replaced by embl, genius by your local cluster. 
- apptainer_tier2 corresponds to the customed parameters for a specific cluster
