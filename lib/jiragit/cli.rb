module Jiragit

  class Cli

    COMMANDS = [
      :install,
      :remove
    ]

    def initialize(args)
     exit_with_help and return if args.empty?
     command = args[0].to_sym
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
      puts "Installing into #{Jiragit::Git.repository_root}"
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

    private

      def gem_hook_paths
        spec = Gem::Specification.find_by_name('jiragit')
        Dir.glob("#{spec.gem_dir}/hooks/*")
      end

      def gem_hook_files
        gem_hook_paths.map { |hook| File.basename(hook) }
      end

  end

end
