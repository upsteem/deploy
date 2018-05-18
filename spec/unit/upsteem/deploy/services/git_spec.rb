require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/services/git")

describe Upsteem::Deploy::Services::Git do
  include_context "setup for git service"
  include_context "examples for git service"

  describe ".new" do
    it_behaves_like "instance creation success"
    it_behaves_like "instance creation failure on missing project path"
  end

  describe "#current_branch" do
    include_context "setup for current_branch"
    it_behaves_like "current_branch instance method in Services::Git"
  end

  describe "#must_be_current_branch!" do
    include_context "setup for must_be_current_branch!"
    it_behaves_like "must_be_current_branch! instance method in Services::Git"
  end

  describe "#status" do
    include_context "setup for status"
    it_behaves_like "status instance method in Services::Git"
  end

  describe "#checkout" do
    include_context "setup for checkout"
    it_behaves_like "checkout instance method in Services::Git"
  end

  describe "#pull" do
    include_context "setup for pull"
    it_behaves_like "pull instance method in Services::Git"
  end

  describe "#must_be_in_sync!" do
    include_context "setup for must_be_in_sync!"
    it_behaves_like "must_be_in_sync! instance method in Services::Git"
  end

  describe "#commit" do
    include_context "setup for commit"
    it_behaves_like "commit instance method in Services::Git"
  end

  describe "#push" do
    include_context "setup for push"
    it_behaves_like "push instance method in Services::Git"
  end

  describe "#create_merge_commit" do
    include_context "setup for create_merge_commit"
    it_behaves_like "create_merge_commit instance method in Services::Git"
  end

  describe "#abort_merge" do
    include_context "setup for abort_merge"
    it_behaves_like "abort_merge instance method in Services::Git"
  end
end
