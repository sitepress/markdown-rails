# Restart the server to see changes made to this file.

# Setup markdown stacks to work with different template handler in Rails.
MarkdownRails.handle :md, :markdown,
  with: :ApplicationMarkdown

# Ideally you can modify `ApplicationMarkdown` to suit your needs without
# needing ERB, but for some reason enabling ERB with markdown is insanely
# popular, so here it is if that's your jam.

# MarkdownRails.handle :markerb,
#   with: :ErbMarkdown
