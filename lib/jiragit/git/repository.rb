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

      def make_a_commit(&block)
        run_command("touch README.md; git add README.md; git commit -m 'a commit'", &block)
      end

      def root
        @path
      end

      private

        attr_accessor :path

        def run_command(command, &block)
          PTY.spawn("cd #{path}; #{command} 2>&1") do |output, input|
            sleep(1) #avoid race conditions
            yield output, input if block_given?
          end
        end

    end

  end

end
