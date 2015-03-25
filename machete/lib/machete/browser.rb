require 'httparty'

module Machete
  Browser = Struct.new(:app) do
    include Retries

    def visit_path(path)
      wait_until(timeout: 10) { @response = HTTParty.get("http://localhost:5000#{path}") }
    end

    def body
      @response.body
    end
  end
end
