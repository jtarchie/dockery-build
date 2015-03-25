module Machete
  module Retries
    class NotFound < RuntimeError; end

    def wait_until(timeout: 1, pause: 0.1, &block)
      start_time = Time.now
      expired = -> { Time.now - start_time > timeout }

      loop do
        begin
          return false if expired.call
          block.call.tap { |val| return val if val }

          sleep(pause)
        rescue
          raise if expired.call
        end
      end
    end

    extend self
  end
end
