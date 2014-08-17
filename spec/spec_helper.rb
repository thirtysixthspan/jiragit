require 'rake'
require 'rspec'
require './lib/jiragit.rb'

RSpec.configure do |config|

  config.before(:suite) do
    install_gemfile
  end

  def install_gemfile
    rake = Rake.application
    rake.init
    rake.load_rakefile
    rake['gem:install'].invoke
  end

  def create_test_repository
    repo_name = 'test_repository'
    repo = Jiragit::Git::Repository.create(repo_name)
    repo.initial_commit
    Dir.chdir repo_name
    Jiragit::Cli.new([:install])
    Dir.chdir '..'
    repo
  end

end

