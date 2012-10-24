require "test_helper"
require "phidgets/logging"

describe Phidgets::Logging do
  it "logs to stdout" do
    stdout, stderr = capture do
      Phidgets::Logging.enable(:verbose)
      Phidgets::Logging.verbose("id", "message")
    end

    stdout.must_match(/VERBOSE: message/)
    stderr.must_be_empty
  end

  it "logs to a file instead of stdout" do
    Tempfile.new("phidgets") do |file|
      stdout, stderr = capture do
        Phidgets::Logging.enable(:verbose, file.path)
        Phidgets::Logging.verbose("id", "message")
      end

      stdout.must_be_empty
      stderr.must_be_empty

      output = file.read
      output.must_match(/VERBOSE,"message"/)
    end
  end

  it "logs when logging level is greater than or equal to message level" do
    stdout, stderr = capture do
      Phidgets::Logging.enable(:info)
      Phidgets::Logging.info("id", "message")
      Phidgets::Logging.verbose("id", "message")
    end

    stdout.must_match(/INFO: message/)
    stdout.wont_match(/VERBOSE: message/)
    stderr.must_be_empty
  end
end

def capture
  stdout, stdout_ = IO.pipe
  stderr, stderr_ = IO.pipe
  original_stdout, original_stderr = STDOUT.dup, STDERR.dup

  begin
    STDOUT.reopen(stdout_) and stdout_.close
    STDERR.reopen(stderr_) and stderr_.close

    yield
  ensure
    STDERR.reopen(original_stderr)
    STDOUT.reopen(original_stdout)
  end

  [stdout.read, stderr.read]
end
