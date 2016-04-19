require 'test_helper'

class SubscriptionMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers
  attr_reader :subscription, :email

  setup do
    @subscription = subscriptions(:one)
    @email = SubscriptionMailer.confirmation_email(@subscription).deliver_now
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  test "should dispatch confirmation email to subscriber" do
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['from@example.com'], email.from
    assert_equal [subscription.email], email.to
    assert_match /please confirm/i, email.subject
  end

  test "should contain confirmation token" do
    confirm_url = Regexp.escape \
      "http://example.org/subscriptions/#{@subscription.id}/confirmation?token=#{@subscription.confirmation_token}"

    assert_match /#{confirm_url}/i, email.text_part.body.to_s.squish
    assert_match /\<a href="#{confirm_url}"\>/im, email.html_part.body.
      to_s.squish
  end
end
