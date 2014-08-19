require './spec/spec_helper'

module Jiragit

  describe Logger do

    subject { Logger.new("test_log") }

    after do
      File.delete('test_log') if File.exists?('test_log')
    end

    it "should initialize" do
      expect(subject).to be_a Logger
    end

    it "should create a log file" do
      subject.info "Test"
      expect(File.exists?('test_log')).to be true
    end

    it "should contain log entries" do
      subject.info "Test"
      contents = `cat test_log`
      expect(contents).to match(/Test/)
    end

    it "should contain hooks names" do
      subject.hook = "post-checkout"
      subject.info "Test"
      contents = `cat test_log`
      expect(contents).to match(/post-checkout/)
    end

  end

end
