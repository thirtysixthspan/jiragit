require 'pty'

module Jiragit

  module Git

    def self.repository_root
      `git rev-parse --show-toplevel`.chomp
    end

    def self.current_branch
      `git symbolic-ref -q HEAD --short`.chomp
    end

    def self.previous_branch
      `git rev-parse --symbolic-full-name --abbrev-ref @{-1}`.chomp
    end

    class Repository

      def self.create(path)
        Dir.mkdir(path) unless Dir.exists?(path)
        `cd #{path}; git init .` unless File.exists?("#{path}/.git")
        repo = self.new(path)
      end

      def initialize(path)
        self.path = path
      end

      def remove
        `rm -rf #{path}` if Dir.exists?(path)
      end

      def checkout_new_branch(branch, &block)
        run_command("git checkout -b #{branch}", &block)
      end

      def checkout_branch(branch, &block)
        run_command("git checkout #{branch}", &block)
      end

      def create(filename, message)
        run_command("echo '#{message}' > #{filename}")
      end

      def add(filename)
        run_command("git add #{filename}")
      end

      def merge(branch)
        run_command("git merge #{branch}")
      end

      def commit(message, &block)
        number = rand(100)
        run_command("echo '#{message}' > .git_commit_body")
        output = run_command({env: "export GIT_EDITOR=$PWD/spec/git_editor.rb", command:"git commit"}, &block)
        run_command("rm .git_commit_body")
        CommitResponse.new(output)
      end

      def make_a_commit(&block)
        number = rand(100)
        output = run_command({env: "export GIT_EDITOR=$PWD/spec/git_editor.rb", command:"echo \"#{number}\" > README.md; git add README.md; git commit"}, &block)
        CommitResponse.new(output)
      end

      def make_a_command_line_commit(&block)
        number = rand(100)
        output = run_command("echo \"#{number}\" > README.md; git add README.md; git commit -m 'command line specified commit message #{number}'", &block)
        CommitResponse.new(output)
      end

      def log(&block)
        run_command("git log", &block)
      end

      def log_for_one_commit(sha, &block)
        run_command("git log -n 1 #{sha}", &block)
      end

      def one_line_log(&block)
        run_command("git log --format=oneline", &block)
      end

      def oneline_log_for_one_commit(sha, &block)
        run_command("git log --format=oneline -n 1 #{sha}", &block)
      end

      def root
        @path
      end

      private

        attr_accessor :path

        def run_command(command, &block)
          if command.is_a? Hash
            env = command[:env]
            command = command[:command]
            full_command = "#{env}; cd #{path}; #{command} 2>&1"
          else
            full_command = "cd #{path}; #{command} 2>&1"
          end
          if block_given?
            PTY.spawn(full_command) do |output, input|
              sleep(1) #avoid race conditions
              yield output, input
            end
          else
            `#{full_command}`
          end
        end

    end

  end

end
