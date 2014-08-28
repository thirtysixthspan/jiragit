require './spec/spec_helper'
require 'expect'

describe "Repository Merge Behaviors" do

  include_context "Test Repository"

  context "when merging a feature branch" do

    before do
      @repo.create('a_file', 'The quick fox jumped over the fence')
      @repo.add('a_file')
      @repo.commit('initial commit')
      checkout_a_new_branch('feature_branch', 'PA-12345')
      @repo.create('a_file', 'The brown fox jumped over the fence')
      @repo.add('a_file')
      @repo.commit('feature commit')
      checkout_a_new_branch('another_feature_branch', 'PA-54321')
      @repo.create('c_file', 'The frog went for a swim')
      @repo.add('c_file')
      @repo.commit('another feature commit')
      checkout_an_existing_branch('master')
      @repo.create('b_file', 'The cow walked to the lake')
      @repo.add('b_file')
      @repo.commit('hotpatch commit')
      checkout_an_existing_branch('feature_branch')
      @repo.create('d_file', 'The crow flew for a while')
      @repo.add('d_file')
      @repo.commit('feature commit number two')
    end

    context "into the master branch without conflicts" do

      it "should relate the jira" do
        checkout_an_existing_branch('master')
        @repo.merge('feature_branch')
        assert_relation({jira: 'PA-12345'}, {branch: 'master'})
      end

      it "should add the jira to the merge commit message" do
        checkout_an_existing_branch('master')
        @repo.merge('feature_branch')
        @repo.log_for_one_commit('HEAD') do |output, input|
          output.expect("PA-12345", 5) do |message|
            expect(message).to_not be nil
          end
        end
      end

    end

    context "into the feature branch without conflicts" do

      it "should relate the jiras" do
        checkout_an_existing_branch('feature_branch')
        @repo.merge('another_feature_branch')
        assert_relation({jira: 'PA-12345'}, {branch: 'feature_branch'})
        assert_relation({jira: 'PA-54321'}, {branch: 'feature_branch'})
      end

      it "should add the current branch jira to the merge commit message" do
        checkout_an_existing_branch('feature_branch')
        @repo.merge('another_feature_branch')
        @repo.log_for_one_commit('HEAD') do |output, input|
          output.expect("PA-12345", 5) do |message|
            expect(message).to_not be nil
          end
        end
      end

      it "should add the merge branch jira to the merge commit message" do
        checkout_an_existing_branch('feature_branch')
        @repo.merge('another_feature_branch')
        @repo.log_for_one_commit('HEAD') do |output, input|
          output.expect("PA-54321", 5) do |message|
            expect(message).to_not be nil
          end
        end
      end

    end

  end

end
