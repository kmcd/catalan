class Article < ActiveRecord::Base
  validates :body, presence:true
  validates :title, presence:true
  has_many :comments, dependent: :destroy
  after_create :notify_subscribers

  def to_param
    [id, title.parameterize].join '-'
  end

  private

  def notify_subscribers
    NotifySubscribersJob.perform_later self
  end
end
