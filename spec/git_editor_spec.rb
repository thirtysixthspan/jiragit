describe "Git Editor Double" do

  context "when making a commit via an editor" do

    it "should add a body to the commit message" do
      @commit_filename = 'commit_message'
      File.delete(@commit_filename) if File.exist?(@commit_filename)
      write_commit_message("#This is the git commit message prepared by git")
      `./spec/git_editor.rb #{@commit_filename}`
      expect(commit_message).to match(/summary of changes/)
      File.delete(@commit_filename) if File.exist?(@commit_filename)
    end

    def commit_message
      File.read(@commit_filename)
    end

    def write_commit_message(message)
      File.write(@commit_filename, message)
    end

  end

end
