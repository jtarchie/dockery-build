RSpec::Matchers.define :be_running do |_|
  include Machete::Retries

  match do |app|
    wait_until(timeout: 60) { app.include?('Starting web app') }
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
