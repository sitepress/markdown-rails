require "markdown/rails/version"
require "markdown/rails/engine"

module MarkdownRails
  def self.handle(*extensions, with: Handler::Markdown, &block)
    with.handle *extensions, &block
  end

  module Handler
    autoload :Markdown,   "markdown/rails/handler/markdown"
    autoload :Erb,        "markdown/rails/handler/erb"
  end

  module Renderer
    autoload :Base,       "markdown/rails/renderer/base"
    autoload :Rails,      "markdown/rails/renderer/rails"
  end
end
