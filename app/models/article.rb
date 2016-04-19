class Article < ActiveRecord::Base
  validates :body, presence:true
  validates :title, presence:true
  has_many :comments, dependent: :destroy
  
  def to_param
    [id, title.parameterize].join '-'
  end
end
