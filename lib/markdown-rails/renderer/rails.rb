module MarkdownRails
  module Renderer
    class Rails < Base
      include ::Rails.application.routes.url_helpers

      def initialize(view:, **extensions)
        super(extensions)
        @view = view
      end

      # The Rails render sets the view, which we can use to delegate everything
      # to from the renderer.
      attr_reader :view

      # Rendering from Markdown is actually outside of the view
      # context, so we need to delegate render to the ApplicationController
      # render method that can render outside of the view context.
      delegate \
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
        :tag,
        :content_tag,
        :request,
        :turbo_frame_tag,
        :controller,
        :raw,
        :request,
        :controller,
      to: :view

      def image(link, title, alt)
        image_tag link, title: title, alt: alt
      end
    end
  end
end
