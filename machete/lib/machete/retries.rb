module Machete
  module Retries
    class NotFound < RuntimeError; end

    def retries(retries=10, duration=1, &block)
      begin
        block.call
      rescue
        if retries > 0
          sleep(duration)
          retries -= 1
          retry
        else
          raise
        end
      end
    end

    extend self
  end
end
