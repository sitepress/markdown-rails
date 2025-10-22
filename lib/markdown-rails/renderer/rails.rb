module MarkdownRails
  module Renderer
    class Rails < Base
      include ::Rails.application.routes.url_helpers

      include ActionView::Helpers::AssetTagHelper
      include ActionView::Helpers::AssetUrlHelper
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::FormTagHelper
      include ActionView::Helpers::TextHelper

      attr_reader :view_context

      def initialize(view_context)
        @view_context = view_context
        super()
      end

      def image(link, title, alt)
        image_tag link, title:, alt:
      end

      # Delegate methods that need view context state.
      # For custom helpers not in ApplicationHelper, access them via view_context:
      #   view_context.my_custom_helper
      # Or delegate them explicitly in your subclass:
      #   delegate :my_custom_helper, to: :view_context
      delegate \
        :render,
        :request,
        :controller,
        :capture,
      to: :view_context

      private
        # These helpers need the view_context's controller and config
        def controller
          view_context.controller
        end

        def config
          view_context.config
        end
    end
  end
end
