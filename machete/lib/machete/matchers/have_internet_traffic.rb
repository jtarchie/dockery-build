RSpec::Matchers.define :have_internet_traffic do
  include Machete::Retries

  match do |app|
    wait_until(timeout: 10) { app.include? 'internet traffic: ' }
  end

  failure_message do |app|
    "\nInternet traffic not detected: \n\n" +
      app.contents
  end

  failure_message_when_negated do |app|
    "\nInternet traffic detected: \n\n" +
      app.contents
  end
end
