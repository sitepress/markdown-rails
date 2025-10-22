module MarkdownRails
  # We cannot use MarkdownRails because it conflicts with RDiscount's Markdown class
  class Handler
    DEFAULT_EXTENSION = :md

    def initialize(class_name: nil, &block)
      @class_name = class_name
      @markdown = block
    end

    def call(template, source = template.source)
      if @class_name
        # Constantize at render time to support class reloading in development
        <<~RUBY
          begin
            renderer_class = #{@class_name.to_s.inspect}.constantize
            renderer = renderer_class.new(self)
            renderer.renderer.render(#{source.inspect}).html_safe
          end
        RUBY
      else
        # Block-based approach
        <<~RUBY
          begin
            renderer_class = #{@markdown.call.inspect}
            
            # Ensure we have a class, not an instance
            if !renderer_class.is_a?(Class)
              raise ArgumentError, "MarkdownRails.handle block must return a class, not an instance. Use `ApplicationMarkdown` instead of `ApplicationMarkdown.new`"
            end
            
            renderer = renderer_class.new(self)
            renderer.renderer.render(#{source.inspect}).html_safe
          end
        RUBY
      end
    end

    def self.handle(*extensions, with: nil, &block)
      raise ArgumentError, "Must provide either `with:` keyword argument or a block" if with.nil? && block.nil?
      raise ArgumentError, "Cannot provide both `with:` keyword argument and a block" if with && block
      
      Array(extensions).each do |extension|
        handler = with ? new(class_name: with) : new(&block)
        ActionView::Template.register_template_handler extension, handler
      end
    end

    # Registers a default `.md` handler for Rails templates. This might be
    # replaced by a handler in the `config/initializers/markdown.rb` file.
    def self.register_default
      handle(DEFAULT_EXTENSION) { MarkdownRails::Renderer::Rails }
    end
  end
end