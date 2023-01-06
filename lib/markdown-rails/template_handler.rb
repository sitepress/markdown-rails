module MarkdownRails
  # We cannot use MarkdownRails because it conflicts with RDiscount's Markdown class
  class TemplateHandler
    def initialize(klass)
      @markdown = klass
    end

    def call(template, source = template.source)
      "#{@markdown.name}.new(content: #{source.inspect}, view: self).call.html_safe"
    end
  end
end
