require "markdown-rails/version"
require "markdown-rails/engine"

module MarkdownRails
  def self.handle(*extensions, with: Handler::Markdown, &block)
    with.handle *extensions, &block
  end

  # This will only work if a `:md` extension, defined in the MarkdownRails::Handler::Markdown::DEFAULT_EXTENSION
  # constant, is NOT registered in Rails template handlers. In a Rails app, this will happen if the user hasn't
  # configured MarkdownRails from the ./config/initializers/markdown.rb directory.
  #
  # To disable this behavior, set the `MarkdownRails.default_extension` to `nil`
  # in `config/initializers/markdown.rb` like this:
  #
  # ```ruby
  # MarkdownRails.default_extension = nil
  # ```
  #
  # Or change the extension to your prerence:
  #
  # ```ruby
  # MarkdownRails.default_extension = :markdown
  # ```
  def self.default_extension=(extension)
    MarkdownRails::Handler::Markdown.default_extension = extension
  end

  module Handler
    autoload :Markdown,   "markdown-rails/handler/markdown"
    autoload :Erb,        "markdown-rails/handler/erb"
  end

  module Renderer
    autoload :Base,       "markdown-rails/renderer/base"
    autoload :Rails,      "markdown-rails/renderer/rails"
  end

  module Helper
    autoload :Rouge,      "markdown-rails/helper/rouge"
  end
end
