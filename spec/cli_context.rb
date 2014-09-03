RSpec.shared_context "CLI input/output" do

  before do
    $stdout = StringIO.new
    $stderr = StringIO.new
  end

  after(:all) do
    $stdout = STDOUT
    $stderr = STDERR
  end

end
