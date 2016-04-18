class Article < ActiveRecord::Base
  validates :body, presence:true
  validates :title, presence:true
end
