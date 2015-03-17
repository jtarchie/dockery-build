require 'spec_helper'

describe 'Deploying an with a different stack' do
  let(:browser) { Machete::Browser.new(app) }

  after { Machete::CF::DeleteApp.new.execute(app) }

  context 'with lucid64' do
    let(:app) { deploy_app(app: 'html', buildpack: 'webbrick', stack: 'lucid64') }

    before do
      browser.visit_path '/stack.rhtml'
    end

    it 'uses the correct rootfs' do
      expect(browser).to have_body 'Ubuntu 10.04.4'
    end

    it 'sets the CF_STACK value' do
      expect_log_env({
        CF_STACK: 'lucid64'
      }, 'compile')
    end
  end

  context 'with lucid64' do
    let(:app) { deploy_app(app: 'html', buildpack: 'webbrick', stack: 'cflinuxfs2') }

    before do
      browser.visit_path '/stack.rhtml'
    end

    it 'uses the correct rootfs' do
      expect(browser).to have_body 'Ubuntu 14.04.2'
    end

    it 'sets the CF_STACK value' do
      expect_log_env({
        CF_STACK: 'cflinuxfs2'
      }, 'compile')
    end
  end
end

