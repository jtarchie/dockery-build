require 'spec_helper'

describe 'When environment variables have been set on the app' do
  let(:browser) { Machete::Browser.new(app) }

  after { Machete::CF::DeleteApp.new.execute(app) }

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

  def expect_log_env(env)
    env.each do |key, value|
      expect(app).to have_logged %Q{#{key}="#{value}"}
    end
  end

  def expect_log_env_not(env)
    env.each do |key, value|
      expect(app).to_not have_logged %Q{#{key}="#{value}"}
    end
  end

  context 'And there system provided variables' do
    let(:app) { deploy_app(app: 'html', buildpack: 'webbrick') }

    it 'has access to them at app runtime' do
      browser.visit_path '/env.rhtml'

      expect_browser_env({
        DATABASE_URL: 'postgres://postgres:postgres@postgres:5432/postgres',
        HOME: '/home/vcap/app',
        MEMORY_LIMIT: '2008m',
        PORT: '4000',
        TMPDIR: '/home/vcap/tmp',
        VCAP_APPLICATION: '{}',
        VCAP_SERVICES: '[]',
        VCAP_APP_HOST: '0.0.0.0',
        VCAP_APP_PORT: '4000'
      })

      # only available in staging
      expect_browser_env_not({
        BUILDPACK_CACHE: '/home/vcap/tmp/cache',
        STAGING_TIMEOUT: 1000
      })
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
          PORT: '4000',
          TMPDIR: '/home/vcap/tmp',
          VCAP_APP_HOST: '0.0.0.0',
          VCAP_APP_PORT: '4000'
        })

        # only avaible in runtime
        expect_log_env_not({
          BUILDPACK_CACHE: '/home/vcap/tmp/cache',
          STAGING_TIMEOUT: 1000
        })
      end
    end
  end

  context 'And there are user provided variables' do
    let(:app) { deploy_app(buildpack: 'webbrick', app: 'html', env: {NAME: 'Sideshow Bob'}) }

    it 'has access to them at app runtime' do
      browser.visit_path '/env.rhtml'

      expect_browser_env({
        NAME: 'Sideshow Bob'
      })
    end

    context 'during the `profile.d` runtime' do
      let(:app) { deploy_app(buildpack: 'webbrick', app: 'html', env: {NAME: 'Sideshow Bob'}) }

      it 'does not have access to them' do
        expect_log_env_not({
          NAME: 'Sideshow Bob'
        })
      end
    end
  end
end

