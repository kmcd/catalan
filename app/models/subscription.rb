class Subscription < ActiveRecord::Base
  validates :email, presence:true,
    format:{ with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\z/i,
    message:'must be a valid email address' }

  before_create :generate_confirmation_token
  after_create  :dispatch_confirmation_email

  def valid?(token)
    self.confirmation_token == token
  end

  private

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64
  end

  def dispatch_confirmation_email
    SubscriptionMailer.confirmation_email(self).deliver_later
  end
end
