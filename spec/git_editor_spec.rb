describe "Git Editor Double" do

  context "when making a commit via an editor" do

    before do
      @commit_message_filename = '.git_commit_message'
      @commit_body_filename = '.git_commit_body'
      delete_commit_message
      delete_commit_body
      write_commit_message("#This is the git commit message prepared by git")
    end

    after do
      delete_commit_message
      delete_commit_body
    end

    it "should add a predefined body to the commit message" do
      run_git_editor
      expect(commit_message).to match(/summary of changes/)
    end

    it "should add a user defined body to the commit message" do
      write_commit_body('this is a test body')
      run_git_editor
      expect(commit_message).to match(/this is a test body/)
    end

    def commit_message
      File.read(@commit_message_filename)
    end

    def commit_body
      File.read(@commit_body_filename)
    end

    def write_commit_message(message)
      File.write(@commit_message_filename, message)
    end

    def delete_commit_message
      File.delete(@commit_message_filename) if File.exist?(@commit_message_filename)
    end

    def write_commit_body(body)
      File.write(@commit_body_filename, body)
    end

    def delete_commit_body
      File.delete(@commit_body_filename) if File.exists?(@commit_body_filename)
    end

    def run_git_editor
      `./spec/git_editor.rb #{@commit_message_filename}`
    end

  end

end
