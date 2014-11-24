class Post < ActiveRecord::Base
  #has_and_belongs_to_many :users
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence:true
  validates :title, presence: true
  validates :post, presence: true

  
end
