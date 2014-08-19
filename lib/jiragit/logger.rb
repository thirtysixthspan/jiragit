require 'logger'
require 'fileutils'

module Jiragit

  class Logger < ::Logger

    attr_accessor :hook

    def initialize(path = nil)
      if path
        @path = path
      else
        @path = ".git/jiragit/jiragit.log"
      end
      FileUtils.mkdir_p directory
      super(@path)
    end

    def format_message(severity, datetime, progname, msg)
      "#{datetime} #{@hook}: #{msg}\n"
    end

    def directory
      dir = @path.gsub(/(^|\/)[^\/]*?$/,'')
      dir = "." if dir == ''
      dir
    end

  end

end
