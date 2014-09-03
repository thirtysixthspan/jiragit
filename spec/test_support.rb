require 'rake'
require './lib/jiragit.rb'
require 'expect'

module TestSupport

  def install_gemfile
    rake = Rake.application
    rake.init
    rake.load_rakefile
    rake['gem:install'].invoke
  end

  def create_test_repository(repository)
    repo = Jiragit::Git::Repository.create(repository)
    repo.make_a_commit
    repo.origin = "git@github.com:thirtysixthspan/jiragit_test.git"
    Dir.chdir repository
    Jiragit::Cli.new([:install, :silent])
    Dir.chdir '..'
    repo
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

  def checkout_a_new_branch_with_default(branch)
    @repo.checkout_new_branch(branch) do |output, input|
      output.expect(']>', 20) do |message|
        puts "new default #{message}" if @debug
        expect(message).to_not be nil
      end
      input.puts ""
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
