require "test_helper"
require "generators/markdown/install/install_generator"

class Markdown::InstallGeneratorTest < Rails::Generators::TestCase
  tests Markdown::InstallGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
