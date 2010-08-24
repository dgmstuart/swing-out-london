class Organiser < ActiveRecord::Base
  has_many :events
  
  default_scope :order => 'name ASC' #sets default search order
  
  validates_presence_of :name
end
