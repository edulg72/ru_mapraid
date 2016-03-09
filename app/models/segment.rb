class Segment < ActiveRecord::Base
  self.table_name = 'vw_segments'
  self.primary_key = 'id'
  
  belongs_to :editor, foreign_key: 'last_edit_by', class_name: 'User'
  belongs_to :street
  belongs_to :area, foreign_key: 'area_id',class_name: 'AreaMapraid' 

  scope :drivable, -> {where('roadtype in (1,2,3,4,6,7,8,15,17,20)')}
  scope :important, -> {where('roadtype in (3,4,6,7)')}
  scope :disconnected, -> {where('not connected')}
  scope :no_name, -> {where('street_id is null')}
  scope :with_speed, -> {where('(not fwddirection or fwdmaxspeed is not null) and (not revdirection or revmaxspeed is not null)')}
  scope :without_speed, -> {where('roadtype in (2,3,4,6,7) and ((fwddirection and fwdmaxspeed is null) or (revdirection and revmaxspeed is null))')}
  scope :unverified_speed, -> {where('(fwddirection and fwdmaxspeedunverified) or (revdirection and revmaxspeedunverified)')}
  scope :wrong_lock, -> {where('(roadtype=2 and coalesce(lock,0) < 2) or (roadtype=7 and coalesce(lock,0) < 3) or (roadtype in (3,4,6) and coalesce(lock,0) < 4)')}
  
  def self.lock_level(max_lock)
    where("lock is null or lock <= ?",max_lock)
  end
end
