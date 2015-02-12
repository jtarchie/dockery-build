RSpec::Matchers.define :have_logged do |expected_entry|
  include Machete::Retries

  match do |app|
    begin
      retries(10, 0.2) do
        raise Machete::Retries::NotFound unless app.include?(expected_entry)
        true
      end
    rescue Machete::Retries::NotFound
      false
    end
  end

  failure_message do |app|
    "\nApp log did not include '#{expected_entry}'\n\n" +
      app.contents
  end

  failure_message_when_negated do |app|
    "\nApp log did include '#{expected_entry}'\n\n" +
      app.contents
  end
end
