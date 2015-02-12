RSpec::Matchers.define :be_running do |_|
  include Machete::Retries

  match do |app|
    begin
      retries(10, 0.2) do
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
