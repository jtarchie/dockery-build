require 'machete/retries'
require 'machete/app'
require 'machete/browser'
require 'machete/logger'
require 'machete/matchers'
require 'machete/version'
require 'pty'
require 'shellwords'

module Machete
  ROOT_PATH = File.join(File.dirname(__FILE__), '..', '..')


  def self.execute(command)
    return *PTY.spawn(command)
  end

  def self.deploy_app(app_name, app_path: nil, buildpack_path: nil, env: {}, start_command: nil)
    app_path ||= File.join(Dir.pwd, 'cf_spec', 'fixtures', app_name)
    buildpack_path ||= Dir.pwd
    deploy_cmd = (["#{ROOT_PATH}/bin/deploy", buildpack_path, app_path, start_command] + env.map{|k,v| ['-e', "#{k}='#{v}'"]}.flatten).shelljoin
    stdout, stdin, _ = execute(deploy_cmd)

    App.new(stdin, stdout)
  end

  module BuildpackMode
    def self.offline?
      false
    end

    def self.online?
      true
    end
  end

  module CF
    class DeleteApp
      def execute(app)
        app.exit!
      end
    end
  end
end



