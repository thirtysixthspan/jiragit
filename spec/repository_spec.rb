require './spec/spec_helper'
require 'expect'

describe "Repository Behaviors" do

  before do
    @repository = "test_repository"
    @repo = create_test_repository(@repository)
    @js = Jiragit::JiraStore.new("#{@repository}/.git/jiragit/jira_store")
    @log = "#{@repository}/.git/jiragit/hooks.log"
    @debug = false
  end

  after do
    @repo.remove
  end

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
          output.expect("JIRA", 5) do |message|
            expect(message).to be nil
          end
        end
      end

    end

  end

  def checkout_a_new_branch(branch, jira="")
    if jira.empty?
      text = branch
    else
      text = 'JIRA'
    end
    @repo.checkout_new_branch(branch) do |output, input|
      output.expect(text, 20) do |message|
        puts "new #{message}" if @debug
        expect(message).to_not be nil
      end
      input.puts(jira) if !jira.empty?
    end
  end

  def checkout_an_existing_branch(branch, jira="")
    if jira.empty?
      text = branch
    else
      text = 'JIRA'
    end
    @repo.checkout_branch(branch) do |output, input|
      output.expect(text, 20) do |message|
        puts "existing #{message}" if @debug
        expect(message).to_not be nil
      end
      input.puts(jira) if !jira.empty?
    end
  end

  def assert_no_relation(first, second)
    sleep(5)
    relations = @js.relations(first)
    expect(relations).to_not include Jiragit::Tag.new(second)
  end

  def assert_relation(first, second)
    sleep(5)
    relations = @js.relations(first)
    expect(relations).to include Jiragit::Tag.new(second)
  end

  def assert_log_contains(regex)
    expect(File.exists?(@log)).to be true
    expect(`cat #{@log}`).to match(regex)
  end

end
