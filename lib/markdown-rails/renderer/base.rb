require 'redcarpet'

module MarkdownRails
  module Renderer
    class Base < Redcarpet::Render::HTML
      def render_options; end

      def enable; end

      def renderer
        ::Redcarpet::Markdown.new(self.class.new(**options), **features)
      end

      private

      def options
        Hash[Array(render_options).map { |opt| [opt, true] }]
      end

      def features
        Hash[Array(enable).map { |feature| [feature, true] }]
      end
    end
  end
end
