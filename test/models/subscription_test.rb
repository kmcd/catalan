require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  setup do
    @subscription = Subscription.new email:'s1@example.org'
  end

  test "should create confirmation token" do
    @subscription.save!

    assert_equal true, @subscription.persisted?
    assert_not @subscription.confirmation_token.blank?
  end

  test "should not be subscribed by default" do
    @subscription.save!

    assert_not @subscription.confirmed
  end

  test "should enqueue confirmation email for dispatch" do
    # TODO: mock/stub out
    skip
  end
end
