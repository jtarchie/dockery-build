require 'spec_helper'

describe 'When environment variables have been set on the app' do
  def expect_env(body, env)
    env.each do |key, value|
      expect(body).to include %Q{#{key}="#{value}"}
    end
  end

  def expect_env_not(body, env)
    env.each do |key, value|
      expect(body).to_not include %Q{#{key}="#{value}"}
    end
  end

  context 'And there system provided variables' do
    it 'has access to them at app runtime' do
      deploy_app(buildpack: 'webbrick', app: 'html') do
        body = get('http://127.0.0.1:5000/env.rhtml')

        expect_env(body, {
          DATABASE_URL: 'postgres://postgres:postgres@postgres:5432/postgres',
          HOME: '/home/vcap/app',
          MEMORY_LIMIT: '2008m',
          PORT: '5000',
          TMPDIR: '/home/vcap/tmp',
          VCAP_APPLICATION: '{}',
          VCAP_SERVICES: '[]',
          VCAP_APP_HOST: '0.0.0.0',
          VCAP_APP_PORT: '5000'
        })

        # only available in staging
        expect_env_not(body, {
          BUILDPACK_CACHE: '/home/vcap/tmp/cache',
          STAGING_TIMEOUT: 1000
        })
      end
    end

    context 'during the `profile.d` runtime' do
      it 'has access to them in app staging' do
        deploy_app(buildpack: 'webbrick', app: 'html') do |output|
          expect_env(output, {
            DATABASE_URL: 'postgres://postgres:postgres@postgres:5432/postgres',
            MEMORY_LIMIT: '2008m',
            VCAP_APPLICATION: '{}',
            VCAP_SERVICES: '[]',
            HOME: '/home/vcap/app',
            PORT: '5000',
            TMPDIR: '/home/vcap/tmp',
            VCAP_APP_HOST: '0.0.0.0',
            VCAP_APP_PORT: '5000'
          })

          # only avaible in runtime
          expect_env_not(output, {
            BUILDPACK_CACHE: '/home/vcap/tmp/cache',
            STAGING_TIMEOUT: 1000
          })
        end
      end
    end
  end

  context 'And there are user provided variables' do
    it 'has access to them at app runtime' do
      deploy_app(buildpack: 'webbrick', app: 'html', env: {NAME: 'Sideshow Bob'}) do |output|
        body = get('http://127.0.0.1:5000/env.rhtml')

        expect_env(body, {
          NAME: 'Sideshow Bob'
        })
      end
    end

    context 'during the `profile.d` runtime' do
      it 'does not have access to them' do
        deploy_app(buildpack: 'webbrick', app: 'html', env: {NAME: 'Sideshow Bob'}) do |output|
          expect_env_not(output, {
            NAME: 'Sideshow Bob'
          })
        end
      end
    end
  end
end

