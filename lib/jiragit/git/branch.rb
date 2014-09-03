module Jiragit

  module Git

    class Branch

      attr_accessor :name, :commit

      def short_name
        @name.gsub(/refs\/heads\//,'')
      end

      def date
        @date ||= Jiragit::Git.timestamp(commit)
      end

      def committer
        @committer ||= Jiragit::Git.committer(commit)
      end

      def short_commit
        commit[0,6]
      end

    end

  end

end
