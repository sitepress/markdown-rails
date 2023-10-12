require_relative "lib/markdown-rails/version"

Gem::Specification.new do |spec|
  spec.name        = "markdown-rails"
  spec.version     = MarkdownRails::VERSION
  spec.authors     = ["Brad Gessler"]
  spec.email       = ["bradgessler@gmail.com"]
  spec.homepage    = "https://github.com/sitepress/markdown-rails"
  spec.summary     = "Markdown templates and partials in Rails."
  spec.description = "Markdown Rails is a comprehensive stack for rendering Markdown templates and partials in Rails."
  spec.license     = "MIT"
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  rails_version = ">= 6.0.0"
  spec.add_dependency "railties", rails_version
  spec.add_dependency "actionview", rails_version
  spec.add_dependency "activesupport", rails_version
  spec.add_dependency "redcarpet", ">= 3.0.0"
end
