class ForumThread < ActiveRecord::Base
  belongs_to :player
  has_many :posts, dependent: :destroy
end
