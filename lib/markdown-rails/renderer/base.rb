require "redcarpet"

module MarkdownRails
  module Renderer
    class Base < Redcarpet::Render::HTML
      def enable
        # This is a very restrictive Markdown renderer that errs on the side of safety.
        # For more details read the docs at https://github.com/vmg/redcarpet#darling-i-packed-you-a-couple-renderer-for-lunch
        [
          :filter_html,
          :no_images,
          :no_links,
          :no_styles,
          :safe_links_only
        ]
      end

      def markdown_renderer
        @markdown_renderer ||= ::Redcarpet::Markdown.new(self, **features)
      end

      private
        def features
          Hash[Array(enable).map{ |feature| [ feature, true ] }]
        end
    end
  end
end
