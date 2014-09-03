require './spec/spec_helper'

module Jiragit

  describe Cli do

    include_context "CLI input/output"

    it "should provide help with no command line options" do
      Cli.new([])
      expect($stdout.string).to match(/Commands/)
    end

    context "in an empty repository" do

      before do
        repository = "test_repository"
        Jiragit::Git::Repository.create(repository)
        Dir.chdir repository
      end

      after do
        Dir.chdir '..'
      end

      it "should not have hooks installed" do
        cli = Cli.new([])
        expect(Dir.exists?(".git")).to be true
        expect(Dir.exists?(".git/hooks")).to be true
        cli.send(:gem_hook_files).each do |hook|
          expect(File.exists?(".git/hooks/#{hook}")).to be false
        end
      end

      it "should install hooks" do
        cli = Cli.new([:install])
        cli.send(:gem_hook_files).each do |hook|
          expect(File.exists?(".git/hooks/#{hook}")).to be true
        end
      end

      it "should uninstalled hooks" do
        cli = Cli.new([:install])
        cli = Cli.new([:uninstall])
        cli.send(:gem_hook_files).each do |hook|
          expect(File.exists?(".git/hooks/#{hook}")).to be false
        end
      end

    end

    context "in a test repository" do

      include_context "Test Repository"

      context "in a new feature branch" do

        before do
          @repo.create('a_file', 'The quick fox jumped over the fence')
          @repo.add('a_file')
          @repo.commit('initial commit')
          checkout_a_new_branch('feature_branch', 'PA-12345')
          @repo.create('a_file', 'The brown fox jumped over the fence')
          @repo.add('a_file')
          @repo.commit('feature commit')
          Dir.chdir @repository
        end

        after do
          Dir.chdir '..'
        end

        it "browses to the current branch by default" do
          expect_any_instance_of(Cli).to receive(:run) do |instance, arg|
            expect(arg).to match(/open/)
            expect(arg).to match(/feature_branch/)
          end
          cli = Cli.new([:browse])
        end

        it "browses to the current jira" do
          expect_any_instance_of(Cli).to receive(:run) do |instance, arg|
            expect(arg).to match(/open/)
            expect(arg).to match(/PA-12345/)
          end
          cli = Cli.new([:browse, 'jira'])
        end

        it "browses to the current branch" do
          expect_any_instance_of(Cli).to receive(:run) do |instance, arg|
            expect(arg).to match(/open/)
            expect(arg).to match(/feature_branch/)
          end
          cli = Cli.new([:browse, 'branch'])
        end

      end

      context "in a new feature branch without a jira" do

        before do
          @repo.create('a_file', 'The quick fox jumped over the fence')
          @repo.add('a_file')
          @repo.commit('initial commit')
          checkout_a_new_branch_with_default('feature_branch')
          @repo.create('a_file', 'The brown fox jumped over the fence')
          @repo.add('a_file')
          @repo.commit('feature commit')
          Dir.chdir @repository
        end

        after do
          Dir.chdir '..'
        end

        it "does not browse to an unspecified jira" do
          expect_any_instance_of(Cli).to_not receive(:run)
          cli = Cli.new([:browse, 'jira'])
        end

      end

    end

  end

end
