class CommitResponse

  def initialize(string)
    @response = string
  end

  def commit_string
    @response[/(?<=\[)(.*?)(?=\])/] || ""
  end

  def branch
    commit_string.split(/ /).first
  end

  def sha
    commit_string.split(/ /).last
  end

  def message
    @response[/.*?(?=\n)/]
  end

end
