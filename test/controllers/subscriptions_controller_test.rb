require 'test_helper'

class SubscriptionsControllerTest < ActionController::TestCase
  setup do
    @subscription = subscriptions(:one)
  end

  test "new should have form elements" do
    get :new
    assert_response :success

    assert_select "form[action='/subscriptions'][method='post']" do
      assert_select "input[type='text'][name='subscription[email]']"
      assert_select "button[type='submit']", 'Send Email Confirmation'
    end
  end

  test "should create subscription" do
    assert_difference('Subscription.count') do
      post :create, subscription: { email: @subscription.email }
    end

    assert_redirected_to root_url
    assert_match /Please check your email to confirm your subscription/i, flash.notice
    # TODO: assert_select flash on page (with layout test?)
  end

  test "should display invalid email errors" do
    [ 'foo@ad', '' ].each do |invalid_email|
      assert_no_difference('Subscription.count') do
        post :create, subscription: { email:invalid_email  }
      end

      assert_template :new

      assert_select "form[action='/subscriptions'][method='post']" do
        assert_select "div.form-group.has-error" do
          css_select("label.control-label[for='email']").each do |label|
            assigns(:subscription).errors.messages.each do |error|
              assert_match /#{error}/m, label.text.squish
            end
          end
        end
      end
    end
  end
  
  test "should have confirmation link" do
    assert_routing \
      "/subscriptions/#{@subscription.id}/confirmation", \
      { controller: "subscriptions", action: "confirmation", id: "#{@subscription.id}" }
  end
  
  test "should confirm email subscription" do
    get :confirmation, id:@subscription,
      token:@subscription.confirmation_token

    assert_redirected_to root_url
    assert_match /subscription confirmed/i, flash.notice
    assert_equal true, assigns(:subscription).confirmed
  end
end
