require 'machete/retries'
require 'machete/app'
require 'machete/browser'
require 'machete/matchers'
require 'machete/version'
require 'pty'
require 'shellwords'

module Machete
  ROOT_PATH = File.join(File.dirname(__FILE__), '..', '..')


  def self.execute(command)
    return *PTY.spawn(command)
  end

  def self.deploy_app(app_name, app_path:, buildpack_path:, env: {}, start_command:)
    deploy_cmd = (["#{ROOT_PATH}/bin/deploy", buildpack_path, app_path, start_command] + env.map{|k,v| ['-e', "#{k}='#{v}'"]}.flatten).shelljoin
    stdout, stdin, _ = execute(deploy_cmd)

    app = App.new(stdin, stdout)

    app
  end

  module CF
    class DeleteApp
      def execute(app)
        app.exit!
      end
    end
  end
end



