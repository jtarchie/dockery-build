require 'open-uri'

module Machete
  Browser = Struct.new(:app) do
    include Retries

    def visit_path(path)
      wait_until(timeout: 10) { @response = open("http://localhost:5000#{path}") }
    rescue
      warn "---- Log from app ----"
      warn app.contents
      raise
    end

    def body
      @response.read
    end
  end
end
