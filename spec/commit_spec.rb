require './spec/spec_helper'
require 'expect'

describe "Repository Commit Behaviors" do

  include_context "Test Repository"

  context "when making a commit" do

    before do
      @repo.make_a_commit
      checkout_a_new_branch('new_branch', 'PA-12345')
      @repo.make_a_commit
    end

    it "should add the related jiras" do
      @repo.log do |output, input|
        output.expect("PA-12345", 5) do |message|
          expect(message).to_not be nil
        end
      end
    end

  end

end
