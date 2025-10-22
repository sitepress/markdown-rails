require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "rails"
  gem "rspec"
  gem "redcarpet"
  gem "rack-test"
end

require "action_controller/railtie"
require "action_view/railtie"
require "rack/test"
require "fileutils"
require_relative "../lib/markdown-rails"

VIEWS_PATH = File.expand_path("views", __dir__)
FileUtils.mkdir_p(File.join(VIEWS_PATH, "pages"))
File.write(
  File.join(VIEWS_PATH, "pages/show.html.md"),
  "# Hello\n\nThis is **markdown**."
)

MarkdownRails.handle :md do
  Class.new(MarkdownRails::Renderer::Rails) do
    def renderer_options
      {}
    end
  end.new
end

class PagesController < ActionController::Base
  self.view_paths = [VIEWS_PATH]
  layout false

  def show
  end
end

class TestApp < Rails::Application
  config.eager_load = false
  config.secret_key_base = "test"
  config.logger = Logger.new(nil)
  config.hosts.clear
  config.active_support.to_time_preserves_timezone = :zone

  routes.append do
    get "/page" => "pages#show"
  end
end

TestApp.initialize!

RSpec.describe "Markdown rendering" do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  it "renders .html.md files" do
    get "/page"
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include("<h1>Hello</h1>")
    expect(last_response.body).to include("<strong>markdown</strong>")
  end
end
