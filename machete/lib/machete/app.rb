require 'ostruct'

module Machete
  class App < OpenStruct
    def started?
      include?('Starting web app')
    end

    def include?(msg)
      command.output.include?(msg)
    end

    def contents
      command.output.dup
    end

    def exit!
      command.close!
    end
  end
end
