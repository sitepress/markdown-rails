# Restart the server to see changes made to this file.

# Setup markdown stacks to work with different template handler in Rails.
# You can use the `with:` keyword argument with a string to support class reloading:
MarkdownRails.handle :md, :markdown, with: "ApplicationMarkdown"

# Or use a block for more complex setups:
# MarkdownRails.handle :md, :markdown do
#   ApplicationMarkdown
# end

# Don't use Erb for untrusted markdown content created by users; otherwise they
# can execute arbitrary code on your server. This should only be used for input you
# trust, like content files from your code repo.
MarkdownRails.handle :markerb, with: "ErbMarkdown"