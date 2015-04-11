require 'httparty'
require 'machete/retries'
require 'machete/app'
require 'machete/browser'
require 'machete/command'
require 'machete/logger'
require 'machete/matchers'
require 'machete/version'

module Machete
  extend Retries

  ROOT_PATH = File.join(File.dirname(__FILE__), '..', '..')

  def self.deploy_app(app_name, with_pg: true, app_path: nil, buildpack_path: ENV['BUILDPACK_PATH'], env: {}, start_command: nil, stack: ENV['CF_STACK'])
    app_path ||= File.join(Dir.pwd, 'cf_spec', 'fixtures', app_name)
    buildpack_path ||= Dir.pwd

    Bundler.with_clean_env do
      Dir.chdir(app_path) do
        `./package.sh` if File.exist?('package.sh')
      end
    end

    Dir.chdir(ROOT_PATH) do
      `./bin/cleanup`
    end

    cmds = ["#{ROOT_PATH}/bin/deploy"]
    cmds += ['-b', buildpack_path] if buildpack_path
    cmds += ['-a', app_path] if app_path
    cmds += ['-s', stack] if stack
    cmds += ['-c', start_command] if start_command
    cmds += ['-u', app_name.gsub(/[^a-zA-Z0-9_.-]/, '')]
    cmds += env.map{|k,v| ['-e', "#{k}='#{v}'"]}.flatten

    deploy_cmd = cmds.shelljoin

    app = App.new(
      name: app_name,
      command: Command.new(deploy_cmd)
    )

    wait_until(timeout: 60) { app.staged? }
    app
  end

  module BuildpackMode
    def self.offline?
      !online?
    end

    def self.online?
      ENV['BUILDPACK_MODE'] == 'online'
    end
  end

  module CF
    class DeleteApp
      def execute(app)
        app.exit!
      end
    end

    class CLI
      def self.url_for_app(*)
        'localhost:5000'
      end
    end
  end
end



