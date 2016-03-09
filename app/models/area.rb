class Area < ActiveRecord::Base
  self.table_name = 'areas_mapraid'
  
  has_many :segments
  
  scope :mapraid, -> {where('id > 100')}
#  scope :others, -> {where('id not in (21,22)')}
end
