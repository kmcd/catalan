class Article < ActiveRecord::Base
  validates :body, presence:true
  validates :title, presence:true
  
  def to_param
    [id, title.parameterize].join '-'
  end
end
