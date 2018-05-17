RSpec.describe "`lkr dashboard import` command", type: :cli do
  it "executes `dashboard import --help` command successfully" do
    output = `lkr dashboard import --help`
    expect(output).to eq <<-OUT
Usage:
  lkr dashboard import FILE DEST_SPACE_ID

Options:
  -h, [--help], [--no-help]  # Display usage information

Import a dashboard from a file
    OUT
  end
end
