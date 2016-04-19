class NotifySubscribersJob < ActiveJob::Base
  queue_as :default

  def perform(article)
    Subscription.list.each do |subscription|
      SubscriptionMailer.
        new_article_email(subscription, article).
        deliver_later
    end
  end
end
