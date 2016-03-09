class User < ActiveRecord::Base
  has_many :segments, foreign_key: 'last_edit_by', class_name: 'Segment'
  has_many :comments, class_name: 'UR', foreign_key: 'last_comment_by'
end
