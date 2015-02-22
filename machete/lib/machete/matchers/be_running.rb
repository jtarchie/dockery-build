RSpec::Matchers.define :be_running do |timeout = 60|
  include Machete::Retries

  match do |app|
    duration = 0.3
    begin
      retries(timeout / duration, duration) do
        raise Machete::Retries::NotFound unless app.include?('Starting web app')
        true
      end
    rescue Machete::Retries::NotFound
      false
    end
  end

  failure_message do |app|
    "App is not running. Logs are:\n" +
      app.contents
  end
end
