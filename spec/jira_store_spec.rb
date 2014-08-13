require './spec/spec_helper'

module Jiragit

  describe JiraStore do

    subject {
      File.delete('.testjirastore') if File.exists?('.testjirastore')
      described_class.new('.testjirastore')
    }

    after do
      File.delete('.testjirastore') if File.exists?('.testjirastore')
    end

    it "should initialize using the default location" do
      expect(described_class.new).to be_a JiraStore
    end

    it "should initialize using a custom location" do
      expect(subject).to be_a JiraStore
    end

    it "should relate a branch to a jira" do
      subject.relate(jira: "PA-12345", branch: "my-feature-branch")
      branch = subject.relations(jira: "PA-12345").first
      expect(branch.label).to eq "my-feature-branch"
    end

    it "should automatically save changes" do
      subject.relate(jira: "PA-12345", branch: "my-feature-branch")
      store = described_class.new('.testjirastore')
      branch = store.relations(jira: "PA-12345").first
      expect(branch.label).to eq "my-feature-branch"
    end

    it "should relate multiple branches to a jira" do
      subject.relate(jira: "PA-12345", branch: "my-feature-branch")
      subject.relate(jira: "PA-12345", branch: "my-second-feature-branch")
      branch = subject.relations(jira: "PA-12345")
      expect(branch.size).to eq 2
      expect(branch.to_a.first.label).to eq "my-feature-branch"
      expect(branch.to_a.last.label).to eq "my-second-feature-branch"
    end

    it "should relate a branch and a commit to a jira" do
      subject.relate(jira: "PA-12345", branch: "my-feature-branch")
      subject.relate(jira: "PA-12345", commit: "3d0ff811d2e4e71ede49d3db7fac71f1f988627e")
      relations = subject.relations(jira: "PA-12345")
      expect(relations.size).to eq 2
      expect(relations.map(&:label)).to include "my-feature-branch"
      expect(relations.map(&:label)).to include "3d0ff811d2e4e71ede49d3db7fac71f1f988627e"
    end

  end

end
