require 'pty'
require 'shellwords'

module Machete
  class Command
    attr_reader :stdout,
                :stdin,
                :pid,
                :command,
                :output

    def initialize(command)
      @command = command
      @stdout, @stdin, @pid = PTY.spawn(command)

      @output = ''
      @thread = Thread.new do
        while buffer = stdout.read(1)
          @output += buffer
        end
      end
    end

    def close!
      @thread.kill
      @stdin.write("\x03")
    end
  end
end
