module MarkdownRails
  module Renderer
    class Rails < Base
      include ::Rails.application.routes.url_helpers

      attr_reader :view_context

      def initialize(view_context, **options)
        @view_context = view_context
        super(**options)
      end

      def image(link, title, alt)
        view_context.image_tag link, title: title, alt: alt
      end

      # Delegate view helpers to view_context since they need view state.
      # The view_context has all helpers properly configured with @output_buffer, etc.
      # For custom helpers, access them via view_context:
      #   view_context.my_custom_helper
      # Or delegate them explicitly in your subclass:
      #   delegate :my_custom_helper, to: :view_context
      delegate \
        :render,
        :link_to,
        :button_to,
        :mail_to,
        :asset_digest_path,
        :asset_path,
        :asset_url,
        :audio_path,
        :audio_tag,
        :audio_url,
        :font_path,
        :font_url,
        :image_path,
        :image_tag,
        :image_url,
        :video_path,
        :video_tag,
        :video_url,
        :javascript_include_tag,
        :stylesheet_link_tag,
        :tag,
        :content_tag,
        :request,
        :turbo_frame_tag,
        :controller,
        :raw,
        :safe_join,
        :capture,
      to: :view_context

      def renderer
        # Override Base#renderer to pass view_context when creating the Redcarpet instance
        ::Redcarpet::Markdown.new(self.class.new(view_context, **features), **features)
      end

      private
        def features
          Hash[Array(enable).map{ |feature| [ feature, true ] }]
        end
    end
  end
end