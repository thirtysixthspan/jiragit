require 'yaml'

module Jiragit

  class Configuration

    def initialize(location)
      self.location = location
      load_or_create
    end

    def load_or_create
      self.config = load || create
    end

    def load
      return false unless File.exists?(location)
      self.config = YAML.load(File.read(location))
    end

    def create
      self.config = {}
      save
      config
    end

    def save
      File.open(location, 'w+') { |file| file.write YAML.dump(config) }
    end

    def [](key)
      config[key]
    end

    def []=(key, value)
      config[key] = value
      save
    end

    def include?(key)
      config.include?(key)
    end

    private

      attr_accessor :config
      attr_accessor :location

  end

end
