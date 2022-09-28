module Markdown
  module Rails
    module Renderers
      class Rails < Base
        include ::Rails.application.routes.url_helpers

        def image(link, title, alt)
          ::ApplicationController.helpers.image_tag link, title: title, alt: alt
        end
      end
    end
  end
end
