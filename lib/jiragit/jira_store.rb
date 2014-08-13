module Jiragit

  class JiraStore

    def initialize(location = "#{Dir.home}/.jira_store")
      self.location = location
    end

    def relate(params)
      tags = extract_tags(params).compact
      vault.relate(*tags)
      vault.save
    end

    def relations(params)
      tag = extract_tags(params).compact.first
      return Set.new unless tag
      vault.relations(tag)
    end

    private

      attr_accessor :location
      attr_reader :vault

      def vault
        @vault ||= Vault.new(location)
      end

      def extract_tags(params)
        jira = branch = commit = nil
        jira = Tag.new(jira: params[:jira]) if params.include?(:jira)
        branch = Tag.new(branch: params[:branch]) if params.include?(:branch)
        commit = Tag.new(commit: params[:commit]) if params.include?(:commit)
        [jira, branch, commit]
      end

  end

end
