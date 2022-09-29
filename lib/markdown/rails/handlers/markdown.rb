module Markdown
  module Rails
    module Handlers
      # We cannot use Markdown::Rails because it conflicts with RDiscount's Markdown class
      class Markdown
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
end
