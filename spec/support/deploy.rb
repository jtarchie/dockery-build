require 'shellwords'
require 'pty'
require 'pry'
require 'httparty'
require 'timeout'

def deploy_app(buildpack:, app:, start_command: "", env: {})
  current_path = File.dirname(__FILE__)
  buildpack_path = File.expand_path(File.join(current_path, '..','fixtures','buildpacks',buildpack))
  app_path = File.expand_path(File.join(current_path, '..', 'fixtures','apps',app))

  raise "Buildpack: #{buildpack} does not exist" unless Dir.exists?(buildpack_path)
  raise "App: #{app} does not exist" unless Dir.exists?(app_path)

  execute('./bin/cleanup')
  deploy_cmd = (['./bin/deploy', buildpack_path, app_path, start_command] + env.map{|k,v| ['-e', "#{k}='#{v}'"]}.flatten).shelljoin
  execute(deploy_cmd) do |stdin, stdout|
    output = ''
    stdout.each_line do |line|
      output += line
      break if line.include?('Starting web app')
    end
    yield(output)
    stdin.puts("\x03") # send Ctrl+C down the pipe
  end
end

def retries(max_retries=10, &block)
  begin
    block.call
  rescue
    max_retries -= 1
    if max_retries > 0
      sleep(0.5)
      retry
    else
      raise
    end
  end
end

def get(url)
  retries(10) do
    HTTParty.get(url).body
  end
end

def execute(command)
  return `#{command}` unless block_given?
  PTY.spawn(command) do |stdout, stdin, pid|
    yield(stdin, stdout) if block_given?
    Process.kill('INT', pid)
  end
end
