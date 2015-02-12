require 'spec_helper'

describe 'When determining a startup command for an app' do
  let(:browser) { Machete::Browser.new(app) }

  after { Machete::CF::DeleteApp.new.execute(app) }

  context 'And the buildpack provides a release `web` process' do
    let(:app) { deploy_app(buildpack: 'webbrick', app: 'html') }

    it 'uses the buildpack release process' do
      browser.visit_path '/index.html'
      expect(browser).to have_body "Hello, World\n"
    end

    context 'And the app provides a Procfile' do
      let(:app) { deploy_app(buildpack: 'webbrick', app: 'procfile') }

      it 'uses the Procfile `web` command' do
        browser.visit_path '/index.html'
        expect(browser).to have_body "Hello, World with Procfile\n"
      end

      context 'And the user provides a start command' do
        let(:start_command) { 'ruby -run -e httpd b/ -p $PORT' }
        let(:app) { deploy_app(buildpack: 'webbrick', app: 'procfile', start_command: start_command) }

        it 'uses the user provides start command' do
          browser.visit_path '/index.html'
          expect(browser).to have_body "Hello, World with start command\n"
        end
      end
    end
  end
end
