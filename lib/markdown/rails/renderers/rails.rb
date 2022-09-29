module Markdown
  module Rails
    module Renderers
      class Rails < Base
        include ::Rails.application.routes.url_helpers

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
          :render,
          :request,
          :turbo_frame_tag,
          :controller,
          :raw,
        to: :helpers

        def image(link, title, alt)
          image_tag link, title: title, alt: alt
        end

        protected
          def helpers
            ::ActionController::Base.helpers
          end
      end
    end
  end
end
