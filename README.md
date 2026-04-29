# Current usage

## how to run
  ```bash
  module load Nextflow
  # run in local
  nextflow run main.nf  -profile conda_wsl/apptainer_wsl/docker_wsl -params-file input.yaml
  # run on the cluster (i.e. from university using the nf-core config)
  module load Nextflow
  nextflow run main_workflow.nf  - profile vsc_kul_uhasselt,genius,apptainer_tier2 -params-file input.yaml
  # run tests
  nf-test test --profile conda ./modules/local/amst/tests/main.nf.test
  ```
- nb: the vsc_kul_uhasselt can be replaced by embl, genius by your local cluster. 
- apptainer_tier2 corresponds to the customed parameters for a specific cluster

## done
- start from a yaml
- strict syntax

## to do
- check on zrange
- with instutional config
