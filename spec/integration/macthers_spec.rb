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
end
