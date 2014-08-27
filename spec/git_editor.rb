#!/usr/bin/env ruby
#
# This is a test double for entering a commit message via an editor
# It always enters the same commit message

def commit_message
  File.read(ARGV[0])
end

def write_commit_message(message)
  File.write(ARGV[0], message)
end

def prepend_to_commit_message(line)
  write_commit_message(line+commit_message)
end

def commit_body
<<-BODY
Short (50 chars or less) summary of changes

More detailed explanatory text, if necessary.  Wrap it to about 72
characters or so.  In some contexts, the first line is treated as the
subject of an email and the rest of the text as the body.  The blank
line separating the summary from the body is critical (unless you omit
the body entirely); tools like rebase can get confused if you run the
two together.

BODY
end

prepend_to_commit_message(commit_body)
