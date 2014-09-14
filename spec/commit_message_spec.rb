require './spec/spec_helper'
require 'expect'

describe "Commit message" do

  include_context "Test Repository"

  context "when making a commit" do

    before do
      @repo.make_a_command_line_commit
      checkout_a_new_branch('new_branch', 'PA-12345')
      @repo.create('a_file', 'The brown fox jumped over the fence')
      @repo.add('a_file')
    end

    it "must be properly formatted" do
      message = <<-COMMIT
Capitalized, short (50 chars or less) summary

More detailed explanatory text, if necessary.  Wrap it to about 72
characters or so.  In some contexts, the first line is treated as the
subject of an email and the rest of the text as the body.  The blank
line separating the summary from the body is critical (unless you omit
the body entirely); tools like rebase can get confused if you run the
two together.
      COMMIT

      @repo.commit(message) do |output, input|
        output.expect("Commit rejected", 5) do |message|
          expect(message).to be nil
        end
      end
    end

    it "must contain a title" do
      message = ""
      @repo.commit(message) do |output, input|
        output.expect("The title of the commit message must be present", 5) do |message|
          expect(message).to_not be nil
        end
        output.expect("Edit commit message? [yes]> ")
        input.puts("no")
      end
    end

    it "the title must not be too long" do
      message = "a"*51
      @repo.commit(message) do |output, input|
        output.expect("The title of the commit message must be no longer than 50 characters", 5) do |message|
          expect(message).to_not be nil
        end
        output.expect("Edit commit message? [yes]> ")
        input.puts("no")
      end
    end

    it "the body must be seperated by at least one new line from the title" do
      message = "Line 1\nLine 2"
      @repo.commit(message) do |output, input|
        output.expect("The commit title and body must be separated by a single blank line", 5) do |message|
          expect(message).to_not be nil
        end
        output.expect("Edit commit message? [yes]> ")
        input.puts("no")
      end
    end

    it "the lines in the body must not be too long" do
      message = "a"*20 + "\n\n" +"b"*73
      @repo.commit(message) do |output, input|
        output.expect("Lines in the body of the commit message must be no longer than 72 characters", 5) do |message|
          expect(message).to_not be nil
        end
        output.expect("Edit commit message? [yes]> ")
        input.puts("no")
      end
    end

  end

end
