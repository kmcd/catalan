class SubscriptionMailer < ApplicationMailer
  def confirmation_email(subscription)
    @confirmation_link = confirmation_subscription_url \
        subscription,
        token:subscription.confirmation_token

    mail to:subscription.email, subject:'Please confirm your subscription'
  end

  def new_article
  end
end
