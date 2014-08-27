require 'rspec'
require './lib/jiragit.rb'
require './spec/test_support.rb'
require './spec/test_repository_context.rb'

RSpec.configure do |config|
  include TestSupport

  config.before(:suite) do
    install_gemfile
  end

end

