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

  def create_test_repository(repository)
    repo = Jiragit::Git::Repository.create(repository)
    repo.make_a_commit
    Dir.chdir repository
    Jiragit::Cli.new([:install, :silent])
    Dir.chdir '..'
    repo
  end

end

