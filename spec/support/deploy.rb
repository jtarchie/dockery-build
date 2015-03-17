require 'pry'
require 'httparty'
require 'timeout'
require 'machete'

def deploy_app(buildpack:, app:, start_command: nil, env: {}, stack: 'lucid64')
  current_path = File.dirname(__FILE__)
  buildpack_path = File.expand_path(File.join(current_path, '..','fixtures','buildpacks',buildpack))
  app_path = File.expand_path(File.join(current_path, '..', 'fixtures','apps',app))

  raise "Buildpack: #{buildpack} does not exist" unless Dir.exists?(buildpack_path)
  raise "App: #{app} does not exist" unless Dir.exists?(app_path)

  `./bin/cleanup`
  app = Machete.deploy_app(app,
                           app_path: app_path,
                           buildpack_path: buildpack_path,
                           start_command: start_command,
                           stack: stack,
                           env: env
                          )
  expect(app).to be_running

  app
end

def expect_browser_env(env)
  env.each do |key, value|
    expect(browser).to have_body %Q{#{key}="#{value}"}
  end
end

def expect_browser_env_not(env)
  env.each do |key, value|
    expect(browser).to_not have_body %Q{#{key}="#{value}"}
  end
end

def expect_log_env(env, pre)
  env.each do |key, value|
    expect(app).to have_logged %Q{#{pre}_#{key}=#{value}}
  end
end

def expect_log_env_not(env, pre)
  env.each do |key, value|
    expect(app).to_not have_logged %Q{#{pre}_#{key}=#{value}}
  end
end
