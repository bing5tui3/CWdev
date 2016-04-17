class Category < ActiveRecord::Base
  # pagination
  self.per_page = 20

  validates(:name, :presence => true, :length => { :maximum => 30 })

  before_save { |u| u.name = u.name.upcase }

end
