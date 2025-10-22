module MarkdownRails
  # We cannot use MarkdownRails because it conflicts with RDiscount's Markdown class
  class Handler
    DEFAULT_EXTENSION = :md

    def initialize(&block)
      @markdown = block
    end

    def call(template, source = template.source)
      # Generate code that fetches the handler instance and calls the block at render time
      handler_object_id = self.object_id
      <<~RUBY
        begin
          handler = ObjectSpace._id2ref(#{handler_object_id})
          renderer = handler.create_renderer
          renderer.view_context = self
          renderer.renderer.render(#{source.inspect}).html_safe
        end
      RUBY
    end

    def create_renderer
      @markdown.call
    end

    def self.handle(*extensions, &block)
      Array(extensions).each do |extension|
        handler = new(&block)
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