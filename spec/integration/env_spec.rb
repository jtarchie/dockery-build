require 'spec_helper'

describe 'When environment variables have been set on the app' do
  let(:browser) { Machete::Browser.new(app) }

  after { Machete::CF::DeleteApp.new.execute(app) }

  context 'And there system provided variables' do
    let(:app) { deploy_app(app: 'html', buildpack: 'webbrick') }

    it 'has access to them at app runtime' do
      browser.visit_path '/env.rhtml'

      expect_browser_env({
        DATABASE_URL: 'postgres://postgres:postgres@postgres:5432/postgres',
        HOME: '/home/vcap/app',
        MEMORY_LIMIT: '2008m',
        PORT: '3000',
        TMPDIR: '/home/vcap/tmp',
        VCAP_APPLICATION: '{}',
        VCAP_SERVICES: '[]',
        VCAP_APP_HOST: '0.0.0.0',
        VCAP_APP_PORT: '3000'
      })

      expect_browser_env_not({
        BUILDPACK_CACHE: '/home/vcap/tmp/cache',
        CF_STACK: 'lucid64',
        STAGING_TIMEOUT: 1000
      })
    end

    context 'during the compile step' do
      let(:app) { deploy_app(app: 'html', buildpack: 'webbrick') }

      it 'has access to them in app staging' do
        expect_log_env({
          CF_STACK: 'lucid64',
          BUILDPACK_CACHE: '/home/vcap/tmp/cache',
          STAGING_TIMEOUT: 1000,
          DATABASE_URL: 'postgres://postgres:postgres@postgres:5432/postgres',
          MEMORY_LIMIT: '2008m',
          VCAP_APPLICATION: '{}',
          VCAP_SERVICES: '[]'
        }, 'compile')

        expect_log_env_not({
          HOME: '/home/vcap/app',
          PORT: '3000',
          TMPDIR: '/home/vcap/tmp',
          VCAP_APP_HOST: '0.0.0.0',
          VCAP_APP_PORT: '3000'
        }, 'compile')
      end
    end

    context 'during the `profile.d` runtime' do
      let(:app) { deploy_app(app: 'html', buildpack: 'webbrick') }

      it 'has access to them in app staging' do
        expect_log_env({
          DATABASE_URL: 'postgres://postgres:postgres@postgres:5432/postgres',
          MEMORY_LIMIT: '2008m',
          VCAP_APPLICATION: '{}',
          VCAP_SERVICES: '[]',
          HOME: '/home/vcap/app',
          PORT: '3000',
          TMPDIR: '/home/vcap/tmp',
          VCAP_APP_HOST: '0.0.0.0',
          VCAP_APP_PORT: '3000'
        }, 'profile')

        expect_log_env_not({
          CF_STACK: 'lucid64',
          BUILDPACK_CACHE: '/home/vcap/tmp/cache',
          STAGING_TIMEOUT: 1000
        }, 'profile')
      end
    end
  end

  context 'And there are user provided variables' do
    context 'during app runtime' do
      let(:app) { deploy_app(buildpack: 'webbrick', app: 'html', env: {NAME: 'Runtime'}) }

      it 'has access to them at app runtime' do
        browser.visit_path '/env.rhtml'

        expect_browser_env({
          NAME: 'Runtime'
        })
      end
    end

    context 'during the `profile.d` runtime' do
      let(:app) { deploy_app(buildpack: 'webbrick', app: 'html', env: {NAME: 'Profile'}) }

      it 'does has access to them' do
        expect_log_env({
          NAME: 'Profile'
        }, 'profile')
      end
    end

    context 'during staging' do
      let(:app) { deploy_app(buildpack: 'webbrick', app: 'html', env: {NAME: 'Staging'}) }

      it 'does has access to them' do
        expect_log_env({
          NAME: 'Staging'
        }, 'compile')
      end
    end
  end
end

