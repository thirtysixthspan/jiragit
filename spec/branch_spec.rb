require './spec/spec_helper'
require 'expect'

describe "Repository Branching Behaviors" do

  include_context "Test Repository"

  context "when checking out a new branch" do

    it "asks for a jira number" do
      checkout_a_new_branch('new_branch', 'PA-12345')
    end

    it "runs the post-checkout hook" do
      checkout_a_new_branch('new_branch', 'PA-12345')
      assert_log_contains(/post-checkout/)
    end

    it "records a jira_branch relation" do
      checkout_a_new_branch('new_branch', 'PA-12345')
      assert_relation({jira: 'PA-12345'}, {branch: 'new_branch'})
    end

    it "records multiple jira_branch relations" do
      checkout_a_new_branch('new_branch', 'PA-12345, PA-54321')
      assert_relation({jira: 'PA-12345'}, {branch: 'new_branch'})
      assert_relation({jira: 'PA-54321'}, {branch: 'new_branch'})
    end

    context "previous branch has associated jiras" do

      before do
        checkout_a_new_branch('parent_branch', 'PA-12345')
        @repo.make_a_commit
      end

      it "should provide and accept defaults" do
        assert_relation({jira: 'PA-12345'}, {branch: 'parent_branch'})
        checkout_a_new_branch_with_default('child_branch')
        assert_relation({jira: 'PA-12345'}, {branch: 'child_branch'})
      end

    end

  end

  context "when checking out an existing branch" do

    context "without an associated jira" do

      before do
        checkout_a_new_branch('new_branch')
        @repo.make_a_commit
        checkout_an_existing_branch('master')
      end

      it "asks for a jira number" do
        checkout_an_existing_branch('new_branch', 'PA-12345')
      end

      it "runs the post-checkout hook" do
        checkout_an_existing_branch('new_branch', 'PA-12345')
        assert_log_contains(/post-checkout/)
      end

      it "has no prexisting jira_branch relation" do
        assert_no_relation({jira: 'PA-12345'}, {branch: 'new_branch'})
      end

      it "records a jira_branch relation" do
        checkout_an_existing_branch('new_branch', 'PA-12345')
        assert_relation({jira: 'PA-12345'}, {branch: 'new_branch'})
      end

    end

    context "with an associated jira" do

      before do
        checkout_a_new_branch('new_branch', 'PA-12345')
        @repo.make_a_commit
        checkout_an_existing_branch('master')
      end

      it "does not ask for a jira number" do
        @repo.checkout_branch('new_branch') do |output, input|
          output.expect("What is the JIRA Number?", 5) do |message|
            expect(message).to be nil
          end
        end
      end

      it "lists associated jira numbers" do
        @repo.checkout_branch('new_branch') do |output, input|
          output.expect("PA-12345", 5) do |message|
            expect(message).to_not be nil
          end
        end
      end

    end

  end

end
