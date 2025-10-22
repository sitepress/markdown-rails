# You should read the docs at https://github.com/vmg/redcarpet and probably
# delete a bunch of stuff below if you don't need it.

class ApplicationMarkdown < MarkdownRails::Renderer::Rails
  # Reformats your boring punctation like " and " into “ and ” so you can look
  # and feel smarter. Read the docs at https://github.com/vmg/redcarpet#also-now-our-pants-are-much-smarter
  include Redcarpet::Render::SmartyPants

  # Run `bundle add rouge` and uncomment the include below for syntax highlighting
  # include MarkdownRails::Helper::Rouge

  # The renderer has access to the view_context, which provides access to:
  # - View helpers (image_tag, link_to, content_tag, etc.)
  # - Asset helpers (image_path, image_url, asset_path, etc.)
  # - URL helpers (root_path, user_path, etc.)
  #
  # Many common helpers are already delegated. You can add more by uncommenting
  # and extending the delegate list in your subclass:
  #
  # delegate \
  #   :current_user,
  #   :some_custom_helper,
  # to: :view_context

  # These flags control features in the Redcarpet renderer, which you can read
  # about at https://github.com/vmg/redcarpet#and-its-like-really-simple-to-use
  # Make sure you know what you're doing if you're using this to render user inputs.
  def enable
    [:fenced_code_blocks]
  end

  # Example of how you might override the images to show embeds, like a YouTube video.
  def image(link, title, alt)
    url = URI(link)
    case url.host
    when "www.youtube.com"
      youtube_tag url, alt
    else
      super
    end
  end

  private
    # This is provided as an example; there's many more YouTube URLs that this wouldn't catch.
    def youtube_tag(url, alt)
      embed_url = "https://www.youtube-nocookie.com/embed/#{CGI.parse(url.query).fetch("v").first}"
      content_tag :iframe,
        src: embed_url,
        width: 560,
        height: 325,
        allow: "encrypted-media; picture-in-picture",
        allowfullscreen: true \
          do alt end
    end
end
