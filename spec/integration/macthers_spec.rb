require 'spec_helper'

describe 'With RSpec matchers' do
  describe '#have_file' do
    let(:app) { deploy_app(app: 'html', buildpack: 'webbrick') }

    after { Machete::CF::DeleteApp.new.execute(app) }

    context 'when the file exist' do
      it 'matches' do
        expect(app).to have_file('index.html')
      end
    end

    context 'when the files does not exist' do
      it 'does not match' do
        expect(app).to_not have_file('nada.html')
      end
    end
  end

  describe '#have_internet_traffic' do

    after { Machete::CF::DeleteApp.new.execute(app) }

    context 'when the buildpack does not access the internet' do
      let(:app) { deploy_app(app: 'html', buildpack: 'webbrick') }

      it 'does not match' do
        expect(app.host).to_not have_internet_traffic
      end
    end

    context 'when the buildpack accesses the internet' do
      let(:app) { deploy_app(app: 'html', buildpack: 'webbrick', env: {URL: 'http://google.com'}) }

      it 'matches' do
        expect(app.host).to have_internet_traffic
      end
    end
  end
end
