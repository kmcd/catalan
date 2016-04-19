class Comment < ActiveRecord::Base
  validates :name, presence:true
  validates :body, presence:true
  validates :email, presence:true,
    format:{ with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\z/i,
    message:'must be a valid email address' }

  belongs_to :article
end
