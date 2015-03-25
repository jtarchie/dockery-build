RSpec::Matchers.define :have_logged do |expected_entry|
  include Machete::Retries

  match do |app|
    wait_until(timeout: 15) { app.include?(expected_entry) }
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
