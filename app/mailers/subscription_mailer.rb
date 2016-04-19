class SubscriptionMailer < ApplicationMailer
  def confirmation_email(subscription)
    @subscription = subscription
  end
  
  def new_article
  end
end
