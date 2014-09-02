RSpec.shared_context "CLI input/output" do

  before do
    $stdout = StringIO.new
  end

  after(:all) do
    $stdout = STDOUT
  end

end
