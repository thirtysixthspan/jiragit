require './spec/spec_helper'
require 'expect'

describe "Repository Commit Behaviors" do

  include_context "Test Repository"

  context "when making a commit" do

    context "via editor" do

      before do
        @repo.make_a_command_line_commit
        checkout_a_new_branch('new_branch', 'PA-12345')
        @commit = @repo.make_a_commit
      end

      it "adds the related jira to the body of the commit message" do
        @repo.log_for_one_commit(@commit.sha) do |output, input|
          output.expect("PA-12345", 5) do |message|
            expect(message).to_not be nil
          end
        end
      end

      it "contains the commit message on the first line" do
        @repo.oneline_log_for_one_commit(@commit.sha) do |output, input|
          output.expect("Short (50 chars or less) summary", 5) do |message|
            expect(message).to_not be nil
          end
        end
      end

      it "relates the jira and the commit" do
        assert_relation({jira: 'PA-12345'}, {commit: @repo.current_commit})
      end

      it "relates the branch and the commit" do
        assert_relation({branch: 'new_branch'}, {commit: @repo.current_commit})
      end

    end

    context "via command line" do

      before do
        @repo.make_a_command_line_commit
        checkout_a_new_branch('new_branch', 'PA-12345')
        @commit = @repo.make_a_command_line_commit
      end

      it "adds the related jira to the body of the commit message" do
        @repo.log_for_one_commit(@commit.sha) do |output, input|
          output.expect("PA-12345", 5) do |message|
            expect(message).to_not be nil
          end
        end
      end

      it "contains the commit message on the first line" do
        @repo.oneline_log_for_one_commit(@commit.sha) do |output, input|
          output.expect("command line specified commit message", 5) do |message|
            expect(message).to_not be nil
          end
        end
      end

      it "relates the jira and the commit" do
        assert_relation({jira: 'PA-12345'}, {commit: @repo.current_commit})
      end

      it "relates the branch and the commit" do
        assert_relation({branch: 'new_branch'}, {commit: @repo.current_commit})
      end

    end

    context "that is amended" do

      before do
        @repo.create('a_file', 'The brown fox jumped over the fence')
        @repo.add('a_file')
        @repo.command_line_commit('add a_file')
        checkout_a_new_branch('new_branch', 'PA-12345')
        @repo.create('b_file', 'The sly dog ran across the stream')
        @repo.add('b_file')
        @commit = @repo.amended_command_line_commit('add b_file')
      end

      it "adds the related jira to the body of the commit message" do
        @repo.log_for_one_commit(@commit.sha) do |output, input|
          output.expect("PA-12345", 5) do |message|
            expect(message).to_not be nil
          end
        end
      end

      it "contains the commit message on the first line" do
        @repo.oneline_log_for_one_commit(@commit.sha) do |output, input|
          output.expect("add b_file", 5) do |message|
            expect(message).to_not be nil
          end
        end
      end

      it "relates the jira and the commit" do
        assert_relation({jira: 'PA-12345'}, {commit: @repo.current_commit})
      end

      it "relates the branch and the commit" do
        assert_relation({branch: 'new_branch'}, {commit: @repo.current_commit})
      end

    end

  end
end
