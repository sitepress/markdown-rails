module MarkdownRails
  # We cannot use MarkdownRails because it conflicts with RDiscount's Markdown class
  class Handler
    DEFAULT_EXTENSION = :md

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

    # Registers a default `.md` handler for Rails templates. This might be
    # replaced by a handler in the `config/initializers/markdown.rb` file.
    def self.register_default
      handle(DEFAULT_EXTENSION) { MarkdownRails::Renderer::Rails.new }
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
