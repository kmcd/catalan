class SubscriptionMailer < ApplicationMailer
  def confirmation_email(subscription)
    @confirmation_link = confirmation_subscription_url \
        subscription,
        token:subscription.confirmation_token

    mail to:subscription.email,
      subject:'Please confirm your subscription'
  end

  def new_article_email(subscription, article)
    @article_link = article_url article

    mail to:subscription.email,
      subject:"New article #{article.title}"
  end
end
