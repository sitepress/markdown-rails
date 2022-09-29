module Markdown
  module Rails
    module Handler
      class Erb < Markdown
        def call(template, source = template.source)
          compiled_source = compile_erb template, source
          # TODO: This won't properly handle initializer blocks. Somehow
          # I need to pass a reference to the block that's passed in.
          "#{markdown.class.name}.new.renderer.render(begin;#{compiled_source};end).html_safe"
        end

        private

        def compile_erb(template, source)
          erb.call(template, source)
        end

        def erb
          ActionView::Template.registered_template_handler(:erb)
        end
      end
    end
  end
end
