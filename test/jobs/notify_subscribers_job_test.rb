require 'test_helper'

class NotifySubscribersJobTest < ActiveJob::TestCase
  setup do
    @article = articles(:one)
    @subscriber = subscriptions(:one)
    @subscriber.update confirmed:true
  end
  
  test "should notify all subscribers" do
    assert_enqueued_jobs Subscription.list.count do
      NotifySubscribersJob.perform_now @article
    end
  end
end
