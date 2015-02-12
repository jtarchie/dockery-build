module Machete
  App = Struct.new(:stdin, :stdout) do
    include Retries

    def initialize(*)
      super
      @output = ''
      @thread = Thread.new do
        while buffer = stdout.read(1)
          @output += buffer
        end
      end
    end

    def started?
      include?('Starting web app')
    end

    def include?(msg)
      @output.include?(msg)
    end

    def contents
      @output.dup
    end

    def exit!
      stdin.write("\x03")
    end
  end
end
