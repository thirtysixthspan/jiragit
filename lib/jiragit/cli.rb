module Jiragit

  class Cli

    COMMANDS = [
      :install,
      :uninstall,
      :jira,
      :branch,
      :jira_branch,
      :browse,
      :remote,
      :local,
      :configure,
      :configuration,
      :build
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

      @config = Jiragit::Configuration.new("#{`echo ~`.chomp}/.jiragit")

      begin
        self.send(command)
      rescue => error
        $stderr.puts error.message
      end
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

    def uninstall
      puts "Uninstalling from #{Jiragit::Git.repository_root}"
      gem_hook_files.each do |hook|
        `rm #{Jiragit::Git.repository_root}/.git/hooks/#{hook}`
      end
    end

    def jira
      if @params.empty? || @params[0].empty?
        warn "Please provide a jira"
        return
      end
      puts "Listing all relations for jira #{@params[0]}"
      puts jira_store.relations(jira: @params[0]).to_a
    end

    def branch
      branch = @params[0] || Jiragit::Git.current_branch
      puts "Listing all relations for branch #{branch}"
      puts jira_store.relations(branch: branch).to_a
    end

    def jira_branch
      puts "Relating jira #{@params[0]} and branch #{@params[1]}"
      jira_store.relate(jira: @params[0], branch: @params[1])
    end

    def browse
      type = :branch
      type, object = classify(*@params) unless @params.empty?
      unless object
        object = case type
        when :jira
          related(:jira, {branch: Jiragit::Git.current_branch}).first
        when :branch
          Jiragit::Git.current_branch
        when :commit
          related(:commit, {branch: Jiragit::Git.current_branch}).first
        end
      end
      self.send("browse_#{type}", object)
    end

    def remote
      # remote branches
      type = (@params[0] || 'branches').to_sym
      case type
      when :branches
        list_remote_branches
      end
    end

    def local
      # local branches
      type = (@params[0] || 'branches').to_sym
      case type
      when :branches
        list_local_branches
      end
    end

    def configure
      if @params.size!=2 || @params.first.empty? || @params.last.empty?
        warn "Please provide parameter and value"
        return
      end
      @config[@params.first.to_sym] = @params.last
      puts "Setting #{@params.first.to_sym} to #{@params.last}"
    end

    def configuration
      puts "Configuration settings"
      @config.each do |key,value|
        puts "#{key} = #{value}"
      end
    end

    def build
      commits = Jiragit::Git.log
      commits.each do |commit|
        commit.jiras.each do |jira|
          puts "relating: commit #{commit.sha} to jira: #{jira}"
          jira_store.relate(commit: commit.sha, jira: jira, save: false)
        end
      end
      jira_store.save
    end

    private

      def jira_store
        @jira_store ||= JiraStore.new("#{Jiragit::Git.repository_root}/.git/jiragit/jira_store")
      end

      def run(command)
        `#{command}`
      end

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

      IS_JIRA = /\b([A-Z]{1,4}-[1-9][0-9]{0,6})\b/
      IS_COMMIT = /\b([0-9a-f]{6,40})\b/
      IS_BRANCH = /\b(?!\/)(?!.*\/\.)(?!.*\.\.)(?!.*\/\/)(?!.*\@\{)(?!.*\\)[^\040\177\s\~\^\:\?\*\[]+(?<!\.lock)(?<!\/)(?<!\.)\b/

      def classify(*params)
        case params.first
        when /jira/
          [ :jira, params.size>1 ? params.last[IS_JIRA] : nil ]
        when /commit/
          [ :commit, params.size>1 ? params.last[IS_COMMIT] : nil ]
        when /branch/
          [ :branch, params.size>1 ? params.last[IS_BRANCH] : nil ]
        when IS_JIRA
          [ :jira, params.first[IS_JIRA] ]
        when IS_COMMIT
          [ :commit, params.first[IS_COMMIT] ]
        when IS_BRANCH
          [ :branch, params.first[IS_BRANCH] ]
        else
          [ nil, nil ]
        end
      end

      def browse_jira(jira)
        if !jira || jira.empty?
          warn "No jira available"
          return
        end
        if !@config[:jira_url]
          warn "No jira_url configured"
          return
        end
        puts "Browsing jira #{jira}"
        puts "Visiting #{@config[:jira_url]}/browse/#{jira}"
        run "open #{@config[:jira_url]}/browse/#{jira}"
      end

      def related(type, relation)
        jiras = jira_store
          .relations(relation)
          .to_a
          .select { |r| r.type == type }
          .map(&:label)
      end

      def browse_branch(branch)
        if !branch || branch.empty?
          warn "No branch available"
          return
        end
        puts "Browsing branch #{branch}"
        url = Jiragit::Git.github_branch_url(branch)
        unless url
          puts "No remote repository found on Github"
          return
        end
        puts "Visiting #{url}"
        run "open #{url}"
      end

      def browse_commit(commit)
        if !commit || commit.empty?
          warn "No commit available"
          return
        end
        puts "Browsing commit #{commit}"
        url = Jiragit::Git.github_commit_url(commit)
        unless url
          puts "No remote repository found on Github"
          return
        end
        puts "Visiting #{url}"
        run "open #{url}"
      end

      def list_remote_branches
        puts "Fetching remote branch information"
        Jiragit::Git.remote_branches.each do |branch|
          puts "#{'%-10.10s'%branch.date}\s\s#{branch.short_commit}\s\s#{'%-10.10s'%branch.committer}\s\s#{branch.short_name}"
        end
      end

      def list_local_branches
        puts "Fetching local branch information"
        Jiragit::Git.local_branches.each do |branch|
          puts "#{'%-10.10s'%branch.date}\s\s#{branch.short_commit}\s\s#{'%-10.10s'%branch.committer}\s\s#{branch.short_name}"
        end
      end

  end

end
