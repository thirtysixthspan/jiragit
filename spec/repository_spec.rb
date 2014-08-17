require './spec/spec_helper'
require 'expect'

describe "Repository Behaviors" do

  before do
    @repo = create_test_repository
  end

  after do
    @repo.remove
  end

  it "asks for a jira number when checking out a new branch" do
    @repo.checkout_new_branch('new_branch') do |output, input|
      output.expect("JIRA", 1) do |message|
        expect(message).to_not be nil
      end
      input.puts('PA-12345')
    end
  end

end
