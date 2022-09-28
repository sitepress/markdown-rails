require "rouge" # bundle add 'rouge' for Code highlighting
require "phlex" # bundle add 'phlex' for Markdown components

class ApplicationMarkdown < Markdown::Rails::Renderers::Base
  include Redcarpet::Render::SmartyPants

  def enable
    [:fenced_code_blocks]
  end

  def block_code(code, language)
    render Views::CodeBlock.new(code, syntax: language)
  end

  def image(link, title, alt)
    url = URI(link)
    case url.host
    when "www.youtube.com"
      render Views::YoutubeEmbed.new(url)
    else
      super
    end
  end

  private
    def render(component)
      component.call
    end
end
