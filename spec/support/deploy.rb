require 'pry'
require 'httparty'
require 'timeout'
require 'machete'

def deploy_app(buildpack:, app:, start_command: nil, env: {})
  current_path = File.dirname(__FILE__)
  buildpack_path = File.expand_path(File.join(current_path, '..','fixtures','buildpacks',buildpack))
  app_path = File.expand_path(File.join(current_path, '..', 'fixtures','apps',app))

  raise "Buildpack: #{buildpack} does not exist" unless Dir.exists?(buildpack_path)
  raise "App: #{app} does not exist" unless Dir.exists?(app_path)

  `./bin/cleanup`
  app = Machete.deploy_app(app, app_path: app_path, buildpack_path: buildpack_path, start_command: start_command, env: env)
  expect(app).to be_running

  app
end
