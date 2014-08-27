RSpec.shared_context "Test Repository" do

  before do
    @repository = "test_repository"
    @repo = create_test_repository(@repository)
    @js = Jiragit::JiraStore.new("#{@repository}/.git/jiragit/jira_store")
    @log = "#{@repository}/.git/jiragit/hooks.log"
    @debug = false
  end

  after do
    @repo.remove
  end

end
