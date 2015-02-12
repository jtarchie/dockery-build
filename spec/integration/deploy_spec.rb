require 'spec_helper'

describe 'Deploying a web application' do
  let(:app) { deploy_app(app: 'html', buildpack: 'webbrick') }
  let(:browser) { Machete::Browser.new(app) }

  after { Machete::CF::DeleteApp.new.execute(app) }

  it 'responds to HTTP requests on port 5000' do
    browser.visit_path '/index.html'
    expect(browser).to have_body "Hello, World"
  end
end
