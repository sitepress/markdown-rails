class Markdown::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def copy_files
    directory "app"
    directory "config"
  end
end
