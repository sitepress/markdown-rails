module Markdown
  module Rails
    module Renderers
      class Base < Redcarpet::Render::HTML
        def enable
          []
        end

        def renderer
          ::Redcarpet::Markdown.new(self.class, **features)
        end

        private
          def features
            Hash[Array(enable).map{ |feature| [ feature, true ] }]
          end
      end
    end
  end
end
