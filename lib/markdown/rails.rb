require "markdown/rails/version"
require "markdown/rails/engine"

module Markdown
  module Rails
    def self.handle(extensions, with: Handlers::Markdown, &block)
      with.handle extensions, &block
    end

    module Handlers
      autoload :Markdown,   "markdown/rails/handlers/markdown"
      autoload :Erb,        "markdown/rails/handlers/erb"
    end

    module Renderers
      autoload :Base,       "markdown/rails/renderers/base"
      autoload :Rails,      "markdown/rails/renderers/rails"
    end
  end
end
