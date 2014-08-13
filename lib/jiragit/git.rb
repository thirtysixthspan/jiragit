module Jiragit

  def self.repository_root
    `git rev-parse --show-toplevel`.chomp
  end

  def self.create_repository(name)
    Dir.mkdir(name) unless Dir.exists?(name)
    `cd #{name}; git init .`
  end

  def self.remove_repository(name)
    `rm -rf #{name}` if Dir.exists?(name)
  end

end
