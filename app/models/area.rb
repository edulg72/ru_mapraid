class Area < ActiveRecord::Base
  self.table_name = 'areas_mapraid'

  has_many :segments
  has_many :pus
  belongs_to :state_shape, foreign_key: :state_id
  has_one :updates, through: :state_shape

#  scope :mapraid, -> {where('id > 100')}
#  scope :others, -> {where('id not in (21,22)')}
end
