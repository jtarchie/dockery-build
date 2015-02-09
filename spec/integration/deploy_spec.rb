require 'spec_helper'

describe 'Deploying a web application' do
  it 'responds to HTTP requests on port 5000' do
    deploy_app(buildpack: 'webbrick', app: 'html') do
      expect(get('http://127.0.0.1:5000/index.html')).to eq "Hello, World\n"
    end
  end
end
