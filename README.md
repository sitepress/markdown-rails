# markdown-rails

> **Note**
> **Everything below is implemented in 2.0.0.alpha.** . You can start using this by adding to `gem "markdown-rails", version: "2.0.0.alpha"` to your Gemfile or by looking at it being used in the https://github.com/bradgessler/view-playground repo.

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

This adds a `config/initializers/markdown.rb` file where you can register template handler for your Markdown renders that are located in `./app/markdown/*.rb`.

Now add views or partials ending in `.md` in your `./app/views/**/**` directories and behold!

### Upgrading from 1.x

Change your applications Gemfile to read:

```ruby
gem "markdown-rails", "~> 2.0.0"
```

Then from the root of your Rails project, run:

```sh
$ bin/rails g markdown:install
```

If you have an existing file in `config/initializers/markdown.rb` you'll need to move those settings over. Note that 1.x used `RDiscount` as the default renderer, which was replaced by `Redcarpet` in 2.x.

## Configuration

Applications commonly need various markdown variants within one application. For example,

```ruby
# ./config/initializers/markdown.rb
# Restart the server to see changes made to this file.

# Setup markdown stacks to work with different template handler in Rails.
MarkdownRails.handle :md do
  ApplicationMarkdown.new
end

MarkdownRails.handle :crazymd do
  MyCrazyMarkdown.new
end
```

### Enable Erb in Markdown

Only enable Erb in Markdown if you trust the source of the file. Do not enable it for markdown provided by users or they will be able to execute arbitrary Ruby code.

To enable Erb, you can tell Rails to render all view files ending with `.markerb` using the `MarkdownRails::Handler::Erb` handler.

```ruby
# ./config/initializers/markdown.rb
MarkdownRails.handle :markerb, with: MarkdownRails::Handler::Erb do
  ApplicationMarkdown.new
end
```

You *could* change `:markerb` to `:md`, but I don't recommend it for all Markdown files or you'll run into problems if you have content like `<%= Time.current %>` inside of an `erb` codefence. You're better off having two configurations: one that handles Erb and another that doesn't, like this:

```ruby
# ./config/initializers/markdown.rb
# Restart the server to see changes made to this file.

# Setup markdown stacks to work with different template handler in Rails.
MarkdownRails.handle :md do
  ApplicationMarkdown.new
end

MarkdownRails.handle :markerb, with: MarkdownRails::Handler::Erb do
  ApplicationMarkdown.new
end
```

## Customizing renderer

You might want to customize your Markdown handler to do things like syntax code highlighting, etc.

```ruby
# ./app/markdown/application_markdown.rb
require "rouge"

class ApplicationMarkdown < RailsMarkdown
  include Redcarpet::Render::SmartyPants

  FORMATTER = Rouge::Formatters::HTMLInline.new("monokai.sublime")

  def enable
    [:fenced_code_blocks]
  end

  def block_code(code, language)
    lexer = Rouge::Lexer.find(language)
    content_tag :pre, class: language do
      raw FORMATTER.format(lexer.lex(code))
    end
  end
end
```

Consider using a componet farmework, like [phlex](https://www.phlex.fun) to generate tags outside of the Rails view context.

## Examples

There's a lot of ways to use Markdown in your Rails app.

### The easy way

Your best bet is to use this with a content management site like https://sitepress.cc/ if you're going to be dealing with a lot of markdown content on your website.

### Static view

In `app/views/home/about.html.md`:

```markdown
# About This Site

*Markdown code goes here ...*
```

Keep in mind that unlike static files dropped in `public`, you still need a matching route, such as `get ':action', :controller => :home`, to route `/about` to `home#about`. You could also [use Sitepress](https://sitepress.cc) to automatically manage these routes for you if you're dealing with a lot of pages.

### Static partial

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

Note: If you are including Markdown partials from a Haml view, `<pre>` blocks inside your Markdown may be indented when Haml is not in ["ugly" (production) mode](http://haml-lang.com/docs/yardoc/file.HAML_REFERENCE.html#ugly-option), causing leading white-space to appear in development mode. To fix this, set `Haml::Template.options[:ugly] = true`.

## Security

Despite Markdown being a static language, you should not use this gem to process untrusted Markdown views (or partials). In other words, do not add Markdown views from a source if you wouldn't trust Erb views from them.
