require 'rspec'
require 'rspec/mocks'
require './lib/jiragit.rb'
require './spec/test_support.rb'
require './spec/test_repository_context.rb'
require './spec/cli_context.rb'

RSpec.configure do |config|
  include TestSupport

  config.color = true
  config.formatter = :documentation

  config.before(:suite) do
    install_gemfile
  end

end

