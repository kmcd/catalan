class Subscription < ActiveRecord::Base
  validates :email, presence:true,
    format:{ with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\z/i,
    message:'must be a valid email address' }

  before_create :generate_tokens
  after_create  :dispatch_confirmation_email

  def self.list
    where(confirmed:true, unsubscribed:false).to_a.uniq &:email
  end

  def self.unsubscribe(token)
    unsubscribe = Subscription.where(unsubscribe_token:token).first
    Subscription.where(email:unsubscribe.email).update_all unsubscribed:true
  end

  def confirmed?(token)
    return unless self.confirmation_token == token
    update confirmed:true
  end

  private

  def generate_tokens
    self.confirmation_token = SecureRandom.urlsafe_base64

    self.unsubscribe_token = Digest::MD5::hexdigest(
      [ email, confirmation_token ].join ).downcase
  end

  def dispatch_confirmation_email
    SubscriptionMailer.confirmation_email(self).deliver_later
  end
end
