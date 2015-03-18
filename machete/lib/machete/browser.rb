require 'httparty'

module Machete
  Browser = Struct.new(:app) do
    include Retries

    def visit_path(path)
      @response = retries(20, 0.3) { HTTParty.get("http://localhost:5000#{path}") }
    end

    def body
      @response.body
    end
  end
end
