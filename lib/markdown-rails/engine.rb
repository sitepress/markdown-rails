module MarkdownRails
  class Engine < ::Rails::Engine
    # Check if the `.md` extension has been registered after the
    # config/initializer files are processed. This makes the `:md`
    # extension work if the user forgot to install the initializers.
    config.after_initialize do
      MarkdownRails::Handler::Markdown.register_default_handler
    end
  end
end
