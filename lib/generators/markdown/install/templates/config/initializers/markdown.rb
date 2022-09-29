# Restart the server to see changes made to this file.

# Setup markdown stacks to work with different template handlers in Rails.
Markdown::Rails.handle :md, :markdown do
  ApplicationMarkdown.new
end

# Don't use Erb for untrusted markdown content created by users; otherwise they
# can execute arbitrary code on your server. This should only be used for input you
# trust, like content files from your code repo.
#
# Make sure you know what you're doing before you uncomment the block below to get
# Erb working with Markdown.

# Markdown::Rails.handle :markerb, with: Markdown::Rails::Handlers::Erb do
#   ApplicationMarkdown.new
# end
