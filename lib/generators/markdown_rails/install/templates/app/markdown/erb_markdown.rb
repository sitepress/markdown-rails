# DANGER! This parses Erb, which means arbitrary Ruby can be run. Make sure
# you trust the source of your markdown and that its not user input.

class ErbMarkdown < ApplicationMarkdown
  # Enables Erb to render for the entire doc before the markdown is rendered.
  # This works great, except when you have an `erb` code fence.
  def preprocess(html)
    view.render inline: html, handler: :erb
  end
end
