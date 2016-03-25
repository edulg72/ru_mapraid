class StateShape < ActiveRecord::Base
  self.table_name = 'states_shapes'
  
  has_one :area, foreign_key: 'id_1'
  belongs_to :updates, foreign_key: 'hasc_1', class_name: 'Update'

end
