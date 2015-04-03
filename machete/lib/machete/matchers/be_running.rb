RSpec::Matchers.define :be_running do |timeout=60|
  include Machete::Retries

  match do |app|
    wait_until(timeout: timeout) do
      app.include?('1 of 1 instances running, 1 started') &&
      !app.include?('0 of 1 instances running, 1 down')
    end
  end

  failure_message do |app|
    "App is not running. Logs are:\n" +
      app.contents
  end

  failure_message_when_negated do |app|
    "App is running. Logs are:\n" +
      app.contents
  end
end
