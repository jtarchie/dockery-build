require 'spec_helper'

describe 'When determining a startup command for an app' do
  context 'And the buildpack provides a release `web` process' do
    it 'uses the buildpack release process' do
      deploy_app(buildpack: 'webbrick', app: 'html') do |output|
        expect(get('http://127.0.0.1:5000/index.html')).to eq "Hello, World\n"
      end
    end

    context 'And the app provides a Procfile' do
      it 'uses the Procfile `web` command' do
        deploy_app(buildpack: 'webbrick', app: 'procfile') do |output|
          expect(get('http://127.0.0.1:5000/index.html')).to eq "Hello, World with Procfile\n"
        end
      end

      context 'And the user provides a start command' do
        it 'uses the user provides start command' do
          deploy_app(buildpack: 'webbrick', app: 'procfile', start_command: 'ruby -run -e httpd b/ -p $PORT') do |output|
            expect(get('http://127.0.0.1:5000/')).to eq "Hello, World with start command\n"
          end
        end
      end
    end
  end
end
