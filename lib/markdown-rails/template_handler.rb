module MarkdownRails
  # We cannot use MarkdownRails because it conflicts with RDiscount's Markdown class
  class TemplateHandler
    def initialize(klass)
      @markdown = klass
    end

    def call(template, source = template.source)
      %[
        markdown = #{@markdown.name}.new(view: self);
        markdown.markdown_renderer.render(#{source.inspect}).html_safe;
      ]
    end
  end
end
