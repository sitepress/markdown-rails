require "markdown-rails/version"
require "markdown-rails/engine"

module MarkdownRails
  def self.handle(*extensions, with:)
    handler = TemplateHandler.new(with)

    extensions.each do |extension|
      ActionView::Template.register_template_handler extension, handler
    end
  end

  autoload :TemplateHandler,  "markdown-rails/template_handler"

  module Renderer
    autoload :Base,           "markdown-rails/renderer/base"
    autoload :Rails,          "markdown-rails/renderer/rails"
  end

  module Helper
    autoload :Rouge,          "markdown-rails/helper/rouge"
  end
end
