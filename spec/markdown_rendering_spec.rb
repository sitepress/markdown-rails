require "rails_helper"

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
