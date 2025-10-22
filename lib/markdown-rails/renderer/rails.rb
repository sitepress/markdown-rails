module MarkdownRails
  module Renderer
    class Rails < Base
      include ::Rails.application.routes.url_helpers

      attr_reader :view_context

      def initialize(view_context)
        @view_context = view_context
        super()
      end

      def image(link, title, alt)
        view_context.image_tag link, title: title, alt: alt
      end

      # Delegate common helper methods to the view_context
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
    end
  end
end
