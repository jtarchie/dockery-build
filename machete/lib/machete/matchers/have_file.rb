RSpec::Matchers.define(:have_file) do |expected_filename|
  match do |app|
    Dir.chdir(File.join(Machete::ROOT_PATH, 'tmp', app.name, 'app')) do
      File.exist?(expected_filename)
    end
  end
end
