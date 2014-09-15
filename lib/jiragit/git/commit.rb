module Jiragit

  module Git

    class Commit

      attr_accessor :log

      def initialize(log)
        @log = log
      end

      def sha
        @sha ||= log[/(?<=commit )[0-9a-f]{40}/]
      end

      def date
        @date ||= log[/(?<=Date:)\s+\b.*?$/].gsub(/^\s+/,'')
      end

      def author
        @author ||= log[/(?<=Author:)\s+\b.*?$/].gsub(/^\s+/,'')
      end

      def merge
        @merge ||= log[/(?<=Merge:)\s+\b.*?$/].gsub(/^\s+/,'')
      end

      def body
        @body ||= log.gsub(/^.*Date:.*?\n/m,'')
      end

      IS_JIRA = /\b([A-Z]{1,4}-[1-9][0-9]{0,6})\b/

      def jiras
        @jiras ||= log.scan(IS_JIRA).to_a.flatten.uniq
      end

    end

  end

end
