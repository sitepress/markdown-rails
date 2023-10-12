module MarkdownRails
  module Handler
    # We cannot use MarkdownRails because it conflicts with RDiscount's Markdown class
    class Markdown
      DEFAULT_EXTENSION = :md

      class_attribute :default_extension, default: DEFAULT_EXTENSION

      def initialize(&block)
        @markdown = block
      end

      def call(template, source = template.source)
        renderer.render(source).inspect + '.html_safe'
      end

      def self.handle(*extensions, &block)
        Array(extensions).each do |extension|
          handler = new &block
          ActionView::Template.register_template_handler extension, handler
        end
      end

      # Checks if a handler has been registered with Rails. If it has, then this does nothing. If it hasn't
      # then this will register a default Rails markdown handler.
      def self.register_default_handler
        if default_extension and ActionView::Template::Handlers.extensions.exclude? default_extension
          handle(default_extension) { MarkdownRails::Renderer::Rails.new }
        end
      end

      private

      def markdown
        @cache = nil unless cache_enabled?
        @cache ||= @markdown.call
      end

      def renderer
        @renderer = nil unless cache_enabled?
        @renderer ||= markdown.renderer
      end

      def cache_enabled?
        ::Rails.configuration.cache_classes
      end
    end
  end
end
