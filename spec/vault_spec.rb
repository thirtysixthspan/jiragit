require './spec/spec_helper'

module Jiragit

  describe Vault do

    let!(:vault) { described_class.new('.testvault') }
    let(:item) { Tag.new(type: 'label') }
    let(:related_item) { Tag.new(type: 'label2') }
    let(:another_related_item) { Tag.new(type: 'label3') }
    let(:a_third_related_item) { Tag.new(type: 'label4') }
    let(:unrelated_item) { Tag.new(type: 'label5') }

    after do
      File.delete('.testvault')
    end

    it "should create a vault file" do
      expect(File.exists?('.testvault')).to be true
    end

    it "should add items" do
      vault.create
      vault.add(item)
      expect(vault.include?(item)).to be true
    end

    it "should relate items" do
      vault.create
      vault.relate(item, related_item)
      vault.add(unrelated_item)
      expect(vault.include?(item)).to be true
      expect(vault.include?(related_item)).to be true
      expect(vault.related?(item, related_item)).to be true
      expect(vault.include?(unrelated_item)).to be true
      expect(vault.related?(item,unrelated_item)).to be false
    end

    it "should relate multiple items" do
      vault.create
      vault.relate(item, related_item, another_related_item)
      vault.add(unrelated_item)
      expect(vault.include?(item)).to be true
      expect(vault.include?(related_item)).to be true
      expect(vault.related?(item, related_item)).to be true
      expect(vault.include?(another_related_item)).to be true
      expect(vault.related?(item, another_related_item)).to be true
      expect(vault.include?(unrelated_item)).to be true
      expect(vault.related?(item, unrelated_item)).to be false
    end

    it "should store relations without self reference" do
      vault.create
      vault.relate(item, related_item, another_related_item)
      expect(vault.relations(item)).not_to include item
      expect(vault.relations(item)).to include related_item
      expect(vault.relations(item)).to include another_related_item
    end

    it "should build relation chains across one item" do
      vault.create
      chain = [item, related_item, another_related_item]
      vault.relate(item, related_item)
      vault.relate(related_item, another_related_item)
      expect(vault.relation_chain(item, another_related_item)).to eq chain
      expect(vault.distally_related?(item, another_related_item)).to eq true
      expect(vault.distally_related?(another_related_item, item)).to eq true
      expect(vault.distally_related?(item, unrelated_item)).to eq false
    end

    it "should build relation chains across more than one item" do
      vault.create
      chain = [item, related_item, another_related_item, a_third_related_item]
      vault.relate(item, related_item)
      vault.relate(related_item, another_related_item)
      vault.relate(another_related_item, a_third_related_item)
      expect(vault.relation_chain(item, a_third_related_item)).to eq chain
      expect(vault.distally_related?(item, a_third_related_item)).to eq true
      expect(vault.distally_related?(a_third_related_item, item)).to eq true
      expect(vault.distally_related?(item, unrelated_item)).to eq false
    end

    it "should save and load thousand items in less than a tenth of a second" do
      vault.create
      1000.times.each do |i|
        tag1 = Tag.new(jira: "PA-#{i}")
        tag2 = Tag.new(branch: "my-feature-branch-#{i}")
        vault.relate(tag1, tag2)
      end

      start_time = Time.now.to_f
      vault.save
      vault.load
      end_time = Time.now.to_f
      expect(end_time - start_time).to be < 0.1
    end

  end

end
