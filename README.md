# markdown-rails

This gem allows you to write static Rails views and partials using the [Markdown](http://daringfireball.net/projects/markdown/syntax) syntax. No more editing prose in HTML!

It is a comprehensive Markdown library for Rails that addresses the following pain points:

* Renders markdown files and partials that you can throw in your Rails view paths, like `./app/views/people/profile.html.md`.
* Parse Erb blocks in markdown files.
* Customize markdown tags like `![]()` to support embeds beyond images like YouTube links, code fences for syntax highlighting, etc.
* Plug into Rails asset pipeline so images defined in Markdown will be loaded from the forever-cached image assets.
* Define multiple markdown renders so you can render more dangerous-user upload markdown content vs markdown that you can trust, like content files checked into your Rails project.

This project is used heavily by https://sitepress.cc to manage content files in Rails, but it can be used on its own for Rails views.

## Usage

Add the following to your application's Gemfile:

```sh
$ bundle add 'markdown-rails'
```

Then from the root of your Rails project, run:

```sh
$ bin/rails g markdown:install
```

This adds a `config/initializers/markdown.rb` file and a few Markdown parser stacks to `./app/markdown` that you can customize.

Now add views or partials ending in `.md` or `.markdown` in your `./app/views/**/**` directories!

## Configuration

Applications commonly need various markdown variants within one application. For example,


```ruby
# ./config/initializers/markdown.rb
# Restart your server after making changes to these files.

# Renders markdown without Erb, which is safe for user inputs
# unless you have some crazy unsafe blocks in the `ApplicationMarkdown` stack.
MarkdownRails::Handler.register :md do
  ApplicationMarkdown.new
end

# Use Erb in markdown templates, which is NOT safe for untrusted inputs
# like blog post from a user. You should only use this for content that
# you trust won't execute arbitrary Ruby code like views and templates in
# your repo.
MarkdownRails::ErbHandler.register :markerb do
  ApplicationMarkdown.new
end
```

You might want to customize your Markdown handlers to do things like syntax code highlighting, etc. Here's what that looks like:

```ruby
# ./app/markdown/application_markdown.rb
class ApplicationMarkdown < RailsMarkdown
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
```

## Examples

Your best bet is to use this with a content management site like https://sitepress.cc/ if you're going to be dealing with a lot of markdown content on your website.

### Static View

In `app/views/home/about.html.md`:

```markdown
# About This Site

*Markdown code goes here ...*
```

Keep in mind that unlike static files dropped in `public`, you still need a matching route, such as `get ':action', :controller => :home`, to route `/about` to `home#about`. You could also [use Sitepress](https://sitepress.cc) to automatically manage these routes for you if you're dealing with a lot of pages.

### Static Partial

In `app/views/posts/edit.html.erb`:

```erb
<form>... dynamic code goes here ...</form>
<div class="help">
  <%= render :partial => "posts/edit_help" %>
</div>
```

In `app/views/posts/_edit_help.html.md`:

```markdown
## How To Edit

This text is written in **Markdown**. :-)
```

Note: If you are including Markdown partials from a Haml view, `<pre>` blocks
inside your Markdown may be indented when Haml is not in ["ugly" (production)
mode](http://haml-lang.com/docs/yardoc/file.HAML_REFERENCE.html#ugly-option),
causing leading white-space to appear in development mode. To fix this, set
`Haml::Template.options[:ugly] = true`.


## Security

Despite Markdown being a static language, you should not use this gem to process untrusted Markdown views (or partials). In other words, do not add Markdown views from a source if you wouldn't trust Erb views from them.
