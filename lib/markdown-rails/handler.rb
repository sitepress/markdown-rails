module MarkdownRails
  # We cannot use MarkdownRails because it conflicts with RDiscount's Markdown class
  class Handler
    DEFAULT_EXTENSION = :md
    @@handlers = {}

    def initialize(extension, &block)
      @extension = extension
      @markdown = block
      @@handlers[@extension] = self
    end

    def call(template, source = template.source)
      # Generate code that fetches the handler and calls the block at render time
      extension = @extension
      <<~RUBY
        begin
          handler = MarkdownRails::Handler.handler_for(#{extension.inspect})
          renderer = handler.create_renderer
          renderer.view_context = self
          renderer.renderer.render(#{source.inspect}).html_safe
        end
      RUBY
    end

    def create_renderer
      @markdown.call
    end

    def self.handler_for(extension)
      @@handlers[extension]
    end

    def self.handle(*extensions, &block)
      Array(extensions).each do |extension|
        handler = new(extension, &block)
        ActionView::Template.register_template_handler extension, handler
      end
    end

    # Registers a default `.md` handler for Rails templates. This might be
    # replaced by a handler in the `config/initializers/markdown.rb` file.
    def self.register_default
      handle(DEFAULT_EXTENSION) { MarkdownRails::Renderer::Rails.new }
    end
  end
end