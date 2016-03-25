class Area < ActiveRecord::Base
  self.table_name = 'areas_mapraid'
  
  has_many :segments
  has_one :state_shape, foreign_key: 'id_1'
  has_one :updates, through: :state_shape
  
#  scope :mapraid, -> {where('id > 100')}
#  scope :others, -> {where('id not in (21,22)')}
end
