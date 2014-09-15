require './spec/spec_helper'

module Jiragit

  describe Configuration do

    let!(:config) { described_class.new('.testconfig') }

    cleanup = ->(x) { File.delete('.testconfig') if File.exist?('.testconfig') }
    before &cleanup
    after &cleanup

    it "should create a config file" do
      config[:a] = 5
      expect(File.exists?('.testconfig')).to be true
    end

    it "should set keys" do
      config[:a] = 5
      expect(config[:a]).to eq(5)
    end

    it "should load keys" do
      config[:a] = 5

      new_config = described_class.new('.testconfig')
      expect(new_config[:a]).to eq(5)
    end

  end

end
