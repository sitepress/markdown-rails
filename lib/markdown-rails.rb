require "markdown-rails/version"
require "markdown-rails/engine"

module MarkdownRails
  def self.handle(*extensions, &block)
    Handler.handle(*extensions, &block)
  end

  autoload :Handler,   "markdown-rails/handler"

  module Renderer
    autoload :Base,       "markdown-rails/renderer/base"
    autoload :Rails,      "markdown-rails/renderer/rails"
  end

  module Helper
    autoload :Rouge,      "markdown-rails/helper/rouge"
  end
end
