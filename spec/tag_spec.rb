require './spec/spec_helper'

module Jiragit

  describe Tag do

    subject { described_class.new tag_type: "tag_label" }

    it "requires a type and label passed in via hash" do
      expect(subject).to be_a Tag
    end

    it "should provide a formatted output" do
      expect(subject.to_s).to eq('tag_type: tag_label')
    end

    it "should be unique in a set based on type and label" do
      tag1 = described_class.new tag_type: "tag_label"
      tag2 = described_class.new tag_type: "tag_label"
      tag3 = described_class.new tag_type: "a_different_tag_label"

      set = Set.new
      set << tag1
      set << tag2
      set << tag3

      expect(set.size).to eq(2)
      expect(set).to include tag1
      expect(set).to include tag2
      expect(set).to include tag3
    end

  end

end
