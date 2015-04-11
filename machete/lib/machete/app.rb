require 'ostruct'

module Machete
  class App < OpenStruct
    def host
      self
    end

    def started?
      include?('1 of 1 instances running, 1 started')
    end

    def staged?
      include?('Uploading droplet')
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
