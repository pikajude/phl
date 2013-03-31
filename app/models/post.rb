class Post < ActiveRecord::Base
  belongs_to :player
  belongs_to :forum_thread
end
