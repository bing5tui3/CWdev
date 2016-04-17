# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  name                  :string
#  admin_type            :string
#  email                 :string
#  password_digest       :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  icode                 :string
#  remember_token        :string
#  portrait_file_name    :string
#  portrait_content_type :string
#  portrait_file_size    :integer
#  portrait_updated_at   :datetime
#

class User < ActiveRecord::Base
  has_secure_password

  has_many :articles, :dependent => :destroy

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  
  # name should not be blank
  validates(:name, :presence => true, :length => { :maximum => 50 })

  # paperclip
  has_attached_file :portrait, 
                    :styles => { :large => "500x500>", :medium => "200x200#", :thumb => "30x30#" },
                    :processors => [:cropper]
                

  validates_attachment_content_type :portrait, :content_type => /\Aimage\/.*\Z/

  # regex for email address
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # turn email address downcase
  before_save { |u| u.email = u.email.downcase }
  before_save :create_remember_token

  # after_update :reprocess_image, :if => :cropping?

  # email address should not be blank and should match with the regex pattern 
  # and should be unique
  validates(:email, 
            :presence   => true, 
            :format     => { :with => VALID_EMAIL_REGEX },
            :uniqueness => { :case_sensitive => false }
           )

  # password should not be less than 6 characters
  validates(:password,
            :presence => true,
            :length   => { :minimum => 6 },
            :on       => :create
           )
  validates(:password_confirmation, :presence => true, :on => :create)

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def get_crop_ratio
    return Paperclip::Geometry.from_file(portrait.path(:original)).width/
           Paperclip::Geometry.from_file(portrait.path(:large)).width
  end

end
