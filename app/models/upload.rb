class Upload < ActiveRecord::Base
  attr_accessible :extension, :filepath, :id, :original_name, :pwd, :salt, :slug
  validates :original_name, :presence => true
end