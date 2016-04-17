class Article < ActiveRecord::Base
  belongs_to :user
  validates :user_id,
            :presence => true
  validates :content,
            :presence => true
  default_scope { order(:created_at => :desc) }
  self.per_page = 3
end

WillPaginate.per_page = 3
