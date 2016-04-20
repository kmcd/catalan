ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def stub_authentication
    @request.env["devise.mapping"] = Devise.mappings[:author]
    sign_in authors(:one)
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end

require 'mocha/mini_test'
