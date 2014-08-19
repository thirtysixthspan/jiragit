module Jiragit

  class Cli

    COMMANDS = [
      :install,
      :remove,
      :jira,
      :branch,
      :jira_branch
    ]

    FLAGS = [
      :silent
    ]

    def initialize(args)
     exit_with_help and return if args.empty?
     @args = args
     command = args[0].to_sym
     @params = args[1..-1]
     exit_with_help and return unless COMMANDS.include?(command)
     self.send(command)
    end

    def exit_with_help
      puts "jira {command}"
      puts
      puts "Commands"
      puts "--------"
      COMMANDS.each do |command|
        puts command
      end
    end

    def install
      puts "Installing into #{Jiragit::Git.repository_root}" unless silent?
      gem_hook_paths.each do |hook|
        `cp #{hook} #{Jiragit::Git.repository_root}/.git/hooks/`
      end
      gem_hook_files.each do |hook|
        `chmod a+x #{Jiragit::Git.repository_root}/.git/hooks/#{hook}`
      end
    end

    def remove
      puts "Removing from #{Jiragit::Git.repository_root}"
      gem_hook_files.each do |hook|
        `rm #{Jiragit::Git.repository_root}/.git/hooks/#{hook}`
      end
    end

    def jira
      puts "Listing all relations for jira #{@params[0]}"
      js = JiraStore.new("#{Jiragit::Git.repository_root}/.git/jiragit/jira_store")
      puts js.relations(jira: @params[0]).to_a
    end

    def branch
      branch = @params[0] || Jiragit::Git.current_branch
      puts "Listing all relations for branch #{branch}"
      js = JiraStore.new("#{Jiragit::Git.repository_root}/.git/jiragit/jira_store")
      puts js.relations(branch: branch).to_a
    end

    def jira_branch
      puts "Relating jira #{@params[0]} and branch #{@params[1]}"
      js = JiraStore.new("#{Jiragit::Git.repository_root}/.git/jiragit/jira_store")
      js.relate(jira: @params[0], branch: @params[1])
    end


    private

      def silent?
        !!@args.detect { |a| a == :silent }
      end

      def gem_hook_paths
        spec = Gem::Specification.find_by_name('jiragit')
        Dir.glob("#{spec.gem_dir}/hooks/*")
      end

      def gem_hook_files
        gem_hook_paths.map { |hook| File.basename(hook) }
      end

  end

end
