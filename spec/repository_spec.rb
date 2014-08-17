require './spec/spec_helper'
require 'expect'

describe "Repository Behaviors" do

  before do
    repository = "test_repository"
    @repo = create_test_repository(repository)
    @js = Jiragit::JiraStore.new("#{repository}/.git/jira_store")
  end

  after do
    @repo.remove
  end

  context "when checking out a new branch" do

    it "asks for a jira number" do
      @repo.checkout_new_branch('new_branch') do |output, input|
        output.expect("JIRA", 5) do |message|
          expect(message).to_not be nil
        end
        input.puts('PA-12345')
      end
    end

    it "records a jira_branch relation" do
      @repo.checkout_new_branch('new_branch') do |output, input|
        output.expect("JIRA", 5) do |message|
          expect(message).to_not be nil
        end
        input.puts('PA-12345')
        sleep(5)
        relations = @js.relations(jira: 'PA-12345')
        tag = Jiragit::Tag.new(branch: 'new_branch')
        expect(relations).to include tag
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
        @repo.checkout_branch('new_branch') do |output, input|
          output.expect("JIRA", 5) do |message|
            expect(message).to_not be nil
          end
          input.puts('PA-12345')
        end
      end

      it "records a jira_branch relation" do
        @repo.checkout_branch('new_branch') do |output, input|
          output.expect("JIRA", 5) do |message|
            expect(message).to_not be nil
          end
          input.puts('PA-12345')
          sleep(5)
          relations = @js.relations(jira: 'PA-12345')
          tag = Jiragit::Tag.new(branch: 'new_branch')
          expect(relations).to include tag
        end
      end

    end

    context "with an associated jira" do

      before do
        checkout_a_new_branch('new_branch', 'PA-12345')
        checkout_an_existing_branch('master')
      end

      it "does not ask for a jira number" do
        @repo.checkout_branch('new_branch') do |output, input|
          output.expect("JIRA", 5) do |message|
            puts message
            expect(message).to be nil
          end
        end
      end

    end

  end

  def checkout_a_new_branch(branch, jira=nil)
    @repo.checkout_new_branch(branch) do |output, input|
      output.expect("JIRA", 5) do |message|
        expect(message).to_not be nil
      end
      input.puts(jira) if jira
    end
  end

  def checkout_an_existing_branch(branch)
    @repo.checkout_branch(branch)
  end

end
