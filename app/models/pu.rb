class Pu < ActiveRecord::Base
  self.table_name = 'vw_pu'

  belongs_to :area

  def link
    "https://www.waze.com/editor/?zoom=5\&lat=#{self.latitude}\&lon=#{self.longitude}\&showpur=#{self.id}\&endshow"
  end

  def location
    "#{self.name.nil? or self.name.strip.empty? ? '['+t('noname')+']' : self.name}"
  end
end
