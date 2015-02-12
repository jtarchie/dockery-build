require 'httparty'

module Machete
  Browser = Struct.new(:app) do
    include Retries

    def visit_path(path)
      @response = retries(10, 0.2) { HTTParty.get("http://localhost:5000#{path}") }
    end

    def body
      @response.body
    end
  end
end
