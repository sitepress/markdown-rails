require 'markdown-rails/version'
require 'markdown-rails/engine'

module MarkdownRails
  def self.handle(*extensions, &block)
    Handler.handle(*extensions, &block)
  end

  autoload :Handler, 'markdown-rails/handler'

  module Renderer
    class << self
      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration)
      end
    end

    class Configuration
      attr_accessor :render_options

      def initialize
        # For option details: https://github.com/vmg/redcarpet?tab=readme-ov-file#darling-i-packed-you-a-couple-renderers-for-lunch
        @render_options = []
      end
    end
    autoload :Base,       'markdown-rails/renderer/base'
    autoload :Rails,      'markdown-rails/renderer/rails'
  end

  module Helper
    autoload :Rouge,      'markdown-rails/helper/rouge'
  end
end
