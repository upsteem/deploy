%w[
  task

  git_status_validation
  target_branch_download
  bundle
  target_branch_upload
  feature_branch_dependent
  feature_branch_comparison
  feature_branch_syncing
  feature_branch_merging

  feature_branch_inclusion_flow
  gems_update_flow

  deployment
  application_deployment
].each do |file|
  require_relative("tasks/#{file}")
end
